`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] packet_address;
    reg [3:0] packet_protocol;
    reg reset;
    wire accepted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .clk(clk),
        .packet_address(packet_address),
        .packet_protocol(packet_protocol),
        .reset(reset),
        .accepted(accepted)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            packet_address = 16'h0;
            packet_protocol = 4'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Valid Packet (Address 1234, Protocol 5)", test_num);
            reset_dut();
            packet_address = 16'h1234;
            packet_protocol = 4'h5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Valid Packet (Address AAAA, Protocol F)", test_num);
            reset_dut();
            packet_address = 16'hAAAA;
            packet_protocol = 4'hF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Invalid Protocol (Address 1234, Protocol A)", test_num);
            reset_dut();
            packet_address = 16'h1234;
            packet_protocol = 4'hA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Invalid Address (Address 0000, Protocol 5)", test_num);
            reset_dut();
            packet_address = 16'h0000;
            packet_protocol = 4'h5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            packet_address = 16'h0000;
            packet_protocol = 4'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: All Ones", test_num);
            reset_dut();
            packet_address = 16'hFFFF;
            packet_protocol = 4'hF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("packet_filter Testbench");
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
        input expected_accepted;
        begin
            if (expected_accepted === (expected_accepted ^ accepted ^ expected_accepted)) begin
                $display("PASS");
                $display("  Outputs: accepted=%b",
                         accepted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: accepted=%b",
                         expected_accepted);
                $display("  Got:      accepted=%b",
                         accepted);
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
        $dumpvars(0,clk, packet_address, packet_protocol, reset, accepted);
    end

endmodule
