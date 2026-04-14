`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Aval;
    reg [7:0] Bval;
    reg cin;
    reg [1:0] op;
    wire [7:0] ALUout;
    wire cout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Aval(Aval),
        .Bval(Bval),
        .cin(cin),
        .op(op),
        .ALUout(ALUout),
        .cout(cout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (op=00) - Basic", test_num);
            Aval = 8'h10;
            Bval = 8'h20;
            cin  = 1'b0;
            op   = 2'b00;

            #1;


            check_outputs(8'h30, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (op=00) - With cin", test_num);
            Aval = 8'h05;
            Bval = 8'h02;
            cin  = 1'b1;
            op   = 2'b00;

            #1;


            check_outputs(8'h08, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (op=00) - Overflow", test_num);
            Aval = 8'hFF;
            Bval = 8'h01;
            cin  = 1'b0;
            op   = 2'b00;

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Variant Addition (op=01)", test_num);
            Aval = 8'h10;
            Bval = 8'h05;
            cin  = 1'b1;
            op   = 2'b01;


            #1;



            check_outputs(8'h15, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND (op=10)", test_num);
            Aval = 8'hAA;
            Bval = 8'hF0;
            cin  = 1'b0;
            op   = 2'b10;

            #1;


            check_outputs(8'hA0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND - Zero Result", test_num);
            Aval = 8'h55;
            Bval = 8'hAA;
            cin  = 1'b0;
            op   = 2'b10;

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left Shift Constant (op=11) - Shift 0", test_num);
            Aval = 8'hFF;
            Bval = 8'h00;
            cin  = 1'b0;
            op   = 2'b11;

            #1;


            check_outputs(8'h01, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left Shift Constant (op=11) - Shift 3", test_num);
            Aval = 8'h00;
            Bval = 8'h03;
            cin  = 1'b0;
            op   = 2'b11;

            #1;


            check_outputs(8'h08, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left Shift Constant (op=11) - Shift 7", test_num);
            Aval = 8'h00;
            Bval = 8'h07;
            cin  = 1'b0;
            op   = 2'b11;

            #1;


            check_outputs(8'h80, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (op=00) - Max values", test_num);
            Aval = 8'hFF;
            Bval = 8'hFF;
            cin  = 1'b1;
            op   = 2'b00;

            #1;


            check_outputs(8'hFF, 1'b1);
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
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_ALUout;
        input expected_cout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUout === (expected_ALUout ^ ALUout ^ expected_ALUout) &&
                expected_cout === (expected_cout ^ cout ^ expected_cout)) begin
                $display("PASS");
                $display("  Outputs: ALUout=%h, cout=%b",
                         ALUout, cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUout=%h, cout=%b",
                         expected_ALUout, expected_cout);
                $display("  Got:      ALUout=%h, cout=%b",
                         ALUout, cout);
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
