`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Rx;
    reg date;
    reg tick;
    wire Check;
    wire [7:0] Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Rx(Rx),
        .date(date),
        .tick(tick),
        .Check(Check),
        .Dout(Dout)
    );
    task testcase001;

        integer i;
        reg [7:0] val;
        begin
            test_num = test_num + 1;
            val = 8'hFF;
            $display("Test %0d: Sending data 8'h%h", test_num, val);

            date = 0; tick = 0; Rx = 0; #20;


            for (i = 0; i < 7; i = i + 1) begin
                Rx = val[7-i];
                date = 1;
                #10 tick = 1;
                #10 tick = 0;
            end

            Rx = val[0];
            date = 1;
            #10 tick = 1;
            #1;

            check_outputs(1'b1, val);
            #10 tick = 0;
            date = 0;
            #10;
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] val;
        begin
            test_num = test_num + 1;
            val = 8'h00;
            $display("Test %0d: Sending data 8'h%h", test_num, val);
            date = 0; tick = 0; Rx = 0; #20;

            for (i = 0; i < 7; i = i + 1) begin
                Rx = val[7-i];
                date = 1;
                #10 tick = 1;
                #10 tick = 0;
            end
            Rx = val[0];
            date = 1;
            #10 tick = 1;
            #1;

            check_outputs(1'b1, val);
            #10 tick = 0;
            date = 0;
            #10;
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] val;
        begin
            test_num = test_num + 1;
            val = 8'hAA;
            $display("Test %0d: Sending data 8'h%h", test_num, val);
            date = 0; tick = 0; Rx = 0; #20;

            for (i = 0; i < 7; i = i + 1) begin
                Rx = val[7-i];
                date = 1;
                #10 tick = 1;
                #10 tick = 0;
            end
            Rx = val[0];
            date = 1;
            #10 tick = 1;
            #1;

            check_outputs(1'b1, val);
            #10 tick = 0;
            date = 0;
            #10;
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] val;
        begin
            test_num = test_num + 1;
            val = 8'h55;
            $display("Test %0d: Sending data 8'h%h", test_num, val);
            date = 0; tick = 0; Rx = 0; #20;

            for (i = 0; i < 7; i = i + 1) begin
                Rx = val[7-i];
                date = 1;
                #10 tick = 1;
                #10 tick = 0;
            end
            Rx = val[0];
            date = 1;
            #10 tick = 1;
            #1;

            check_outputs(1'b1, val);
            #10 tick = 0;
            date = 0;
            #10;
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] val;
        begin
            test_num = test_num + 1;
            val = 8'h3C;
            $display("Test %0d: Sending data 8'h%h", test_num, val);
            date = 0; tick = 0; Rx = 0; #20;

            for (i = 0; i < 7; i = i + 1) begin
                Rx = val[7-i];
                date = 1;
                #10 tick = 1;
                #10 tick = 0;
            end
            Rx = val[0];
            date = 1;
            #10 tick = 1;
            #1;

            check_outputs(1'b1, val);
            #10 tick = 0;
            date = 0;
            #10;
        end
        endtask

    task testcase006;

        integer i;
        reg [7:0] val;
        begin
            test_num = test_num + 1;
            val = 8'hA5;
            $display("Test %0d: Sending data 8'h%h", test_num, val);
            date = 0; tick = 0; Rx = 0; #20;

            for (i = 0; i < 7; i = i + 1) begin
                Rx = val[7-i];
                date = 1;
                #10 tick = 1;
                #10 tick = 0;
            end
            Rx = val[0];
            date = 1;
            #10 tick = 1;
            #1;

            check_outputs(1'b1, val);
            #10 tick = 0;
            date = 0;
            #10;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_Check;
        input [7:0] expected_Dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Check === (expected_Check ^ Check ^ expected_Check) &&
                expected_Dout === (expected_Dout ^ Dout ^ expected_Dout)) begin
                $display("PASS");
                $display("  Outputs: Check=%b, Dout=%h",
                         Check, Dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Check=%b, Dout=%h",
                         expected_Check, expected_Dout);
                $display("  Got:      Check=%b, Dout=%h",
                         Check, Dout);
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

endmodule
