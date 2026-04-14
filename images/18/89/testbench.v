`timescale 1ns/1ps

module pcie_packet_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg packet_valid;
    reg reset;
    wire [7:0] packet_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_packet_counter dut (
        .clk(clk),
        .packet_valid(packet_valid),
        .reset(reset),
        .packet_count(packet_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            packet_valid = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Single Packet Increment", test_num);
            reset_dut();
            packet_valid = 1;
            @(posedge clk);
            packet_valid = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Multiple Consecutive Packets (10 packets)", test_num);
            reset_dut();
            repeat(10) begin
                packet_valid = 1;
                @(posedge clk);
            end
            packet_valid = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Intermittent Packets", test_num);
            reset_dut();
            packet_valid = 1; @(posedge clk);
            packet_valid = 0; @(posedge clk);
            packet_valid = 0; @(posedge clk);
            packet_valid = 1; @(posedge clk);
            packet_valid = 1; @(posedge clk);
            packet_valid = 0; @(posedge clk);
            packet_valid = 1; @(posedge clk);
            packet_valid = 0; @(posedge clk);
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Counter Rollover (256 packets)", test_num);
            reset_dut();
            repeat(256) begin
                packet_valid = 1;
                @(posedge clk);
            end
            packet_valid = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Reset Mid-Count", test_num);
            reset_dut();
            repeat(15) begin
                packet_valid = 1;
                @(posedge clk);
            end
            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Maximum Count Check (255 packets)", test_num);
            reset_dut();
            repeat(255) begin
                packet_valid = 1;
                @(posedge clk);
            end
            packet_valid = 0;
            @(posedge clk);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_packet_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_packet_count;
        begin
            if (expected_packet_count === (expected_packet_count ^ packet_count ^ expected_packet_count)) begin
                $display("PASS");
                $display("  Outputs: packet_count=%h",
                         packet_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_count=%h",
                         expected_packet_count);
                $display("  Got:      packet_count=%h",
                         packet_count);
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
        $dumpvars(0,clk, packet_valid, reset, packet_count);
    end

endmodule
