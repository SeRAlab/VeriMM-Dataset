`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] disp_num;
    wire [3:0] anode;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .disp_num(disp_num),
        .anode(anode),
        .seg(seg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            disp_num = 16'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking Digit 0 (LSB) for 0x1234", test_num);
            reset_dut();
            disp_num = 16'h1234;


            #100;
            #1;

            check_outputs(4'b1110, 7'h66);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Checking Digit 1 after 1ms for 0x1234", test_num);
            reset_dut();
            disp_num = 16'h1234;
            #1000000;
            #100;


            #1;



            check_outputs(4'b1101, 7'h4f);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking Digit 2 after 2ms for 0x5678", test_num);
            reset_dut();
            disp_num = 16'h5678;
            #2000000;
            #100;


            #1;



            check_outputs(4'b1011, 7'h7d);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Checking Digit 3 after 3ms for 0xABCD", test_num);
            reset_dut();
            disp_num = 16'hABCD;
            #3000000;
            #100;


            #1;



            check_outputs(4'b0111, 7'h77);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Checking Hex Digit 'F' on Digit 0", test_num);
            reset_dut();
            disp_num = 16'hFFFF;
            #100;

            #1;


            check_outputs(4'b1110, 7'h71);
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
        input [3:0] expected_anode;
        input [6:0] expected_seg;
        begin
            if (expected_anode === (expected_anode ^ anode ^ expected_anode) &&
                expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: anode=%h, seg=%h",
                         anode, seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: anode=%h, seg=%h",
                         expected_anode, expected_seg);
                $display("  Got:      anode=%h, seg=%h",
                         anode, seg);
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
        $dumpvars(0,clk, disp_num, anode, seg);
    end

endmodule
