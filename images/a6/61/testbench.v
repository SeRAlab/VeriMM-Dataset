`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] inA;
    reg [1:0] inB;
    reg [1:0] inC;
    reg [1:0] inD;
    reg [1:0] notIE;
    reg [1:0] sel;
    wire [1:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inA(inA),
        .inB(inB),
        .inC(inC),
        .inD(inD),
        .notIE(notIE),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select inA with enable low (notIE=00)", test_num);
            inA = 2'b11; inB = 2'b00; inC = 2'b10; inD = 2'b01;
            sel = 2'b00;
            notIE = 2'b00;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select inB with enable low (notIE=00)", test_num);
            inA = 2'b11; inB = 2'b10; inC = 2'b01; inD = 2'b00;
            sel = 2'b01;
            notIE = 2'b00;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select inC with enable low (notIE=00)", test_num);
            inA = 2'b11; inB = 2'b10; inC = 2'b01; inD = 2'b00;
            sel = 2'b10;
            notIE = 2'b00;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select inD with enable low (notIE=00)", test_num);
            inA = 2'b11; inB = 2'b10; inC = 2'b01; inD = 2'b00;
            sel = 2'b11;
            notIE = 2'b00;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Disable output (notIE=11) while sel=00", test_num);
            inA = 2'b11; inB = 2'b10; inC = 2'b01; inD = 2'b00;
            sel = 2'b00;
            notIE = 2'b11;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Partial disable check (notIE=01) while sel=01", test_num);


            inA = 2'b11; inB = 2'b11; inC = 2'b11; inD = 2'b11;
            sel = 2'b01;
            notIE = 2'b01;


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs same, toggling enable", test_num);
            inA = 2'b10; inB = 2'b10; inC = 2'b10; inD = 2'b10;
            sel = 2'b10;
            notIE = 2'b00;
            #5;
            notIE = 2'b11;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum value check", test_num);
            inA = 2'b11; inB = 2'b11; inC = 2'b11; inD = 2'b11;
            sel = 2'b11;
            notIE = 2'b00;
            #1;

            check_outputs(2'b11);
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
        testcase007();
        testcase008();
        
        
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
        input [1:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
