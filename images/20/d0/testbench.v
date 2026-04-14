`timescale 1ns/1ps

module pcie_packet_receiver_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] packet_in;
    reg packet_valid;
    reg rst_n;
    wire valid_packet;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_packet_receiver dut (
        .clk(clk),
        .packet_in(packet_in),
        .packet_valid(packet_valid),
        .rst_n(rst_n),
        .valid_packet(valid_packet)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            packet_in = 16'b0;
            packet_valid = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Valid Packet Header (1010...)", test_num);
            reset_dut();

            @(posedge clk);
            packet_in = 16'hA123;
            packet_valid = 1;

            @(posedge clk);
            packet_valid = 0;
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Invalid Packet Header (Not 1010...)", test_num);
            reset_dut();

            @(posedge clk);
            packet_in = 16'h5555;
            packet_valid = 1;

            @(posedge clk);
            packet_valid = 0;
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Correct Header with packet_valid=0", test_num);
            reset_dut();

            @(posedge clk);
            packet_in = 16'hAFFF;
            packet_valid = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Valid Packet Header with All Ones Payload", test_num);
            reset_dut();

            @(posedge clk);
            packet_in = 16'hAFFF;
            packet_valid = 1;

            @(posedge clk);
            packet_valid = 0;
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Packet", test_num);
            reset_dut();

            @(posedge clk);
            packet_in = 16'h0000;
            packet_valid = 1;

            @(posedge clk);
            packet_valid = 0;
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Output during Active Reset", test_num);
            reset_dut();

            @(posedge clk);
            rst_n = 0;
            packet_in = 16'hA123;
            packet_valid = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
            rst_n = 1;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_packet_receiver Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_valid_packet;
        begin
            if (expected_valid_packet === (expected_valid_packet ^ valid_packet ^ expected_valid_packet)) begin
                $display("PASS");
                $display("  Outputs: valid_packet=%b",
                         valid_packet);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid_packet=%b",
                         expected_valid_packet);
                $display("  Got:      valid_packet=%b",
                         valid_packet);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, packet_in, packet_valid, rst_n, valid_packet);
    end

endmodule
