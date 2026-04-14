`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] addr;
    reg [15:0] din;
    reg we;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .din(din),
        .we(we),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Write and Read at Address 0x00", test_num);

            we = 0; addr = 8'h00; din = 16'h0000;
            #10;


            we = 1; addr = 8'h00; din = 16'hAAAA;
            #10;


            we = 0; addr = 8'h00;
            #10;


            #1;



            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Write and Read at Max Address (0xFF)", test_num);

            we = 0; addr = 8'h00; din = 16'h0000;
            #10;


            we = 1; addr = 8'hFF; din = 16'h5555;
            #10;


            we = 0; addr = 8'hFF;
            #10;


            #1;



            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Verify Address Isolation", test_num);

            we = 0; addr = 8'h00; din = 16'h0000;
            #10;


            we = 1; addr = 8'h10; din = 16'h1234;
            #10;

            we = 1; addr = 8'h20; din = 16'h5678;
            #10;


            we = 0; addr = 8'h10;
            #10;


            #1;



            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Overwrite Data", test_num);

            we = 0; addr = 8'h00; din = 16'h0000;
            #10;


            we = 1; addr = 8'h33; din = 16'hBBBB;
            #10;

            we = 1; addr = 8'h33; din = 16'h3333;
            #10;


            we = 0; addr = 8'h33;
            #10;


            #1;



            check_outputs(16'h3333);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Boundary Data Values", test_num);

            we = 0; addr = 8'h00; din = 16'h0000;
            #10;


            we = 1; addr = 8'hAA; din = 16'hFFFF;
            #10;

            we = 1; addr = 8'h55; din = 16'h0000;
            #10;


            we = 0; addr = 8'hAA;
            #10;


            #1;



            check_outputs(16'hFFFF);
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
        input [15:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
