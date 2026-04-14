`timescale 1ns/1ps

module bitwise_operation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a_in;
    reg [7:0] b_in;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_operation dut (
        .a_in(a_in),
        .b_in(b_in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros input", test_num);
            a_in = 8'b0000_0000;
            b_in = 8'b0000_0000;



            #1;




            check_outputs(8'h02);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: XOR=1, XNOR=1", test_num);
            a_in = 8'b0000_0001;
            b_in = 8'b0000_0000;


            #1;



            check_outputs(8'h03);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: XOR=0, XNOR=0", test_num);
            a_in = 8'b0000_0000;
            b_in = 8'b0000_0010;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: XOR=1, XNOR=0", test_num);
            a_in = 8'b0000_0011;
            b_in = 8'b0000_0000;


            #1;



            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones inputs", test_num);
            a_in = 8'b1111_1111;
            b_in = 8'b1111_1111;


            #1;



            check_outputs(8'h02);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High bits check (High bits should not affect result)", test_num);
            a_in = 8'b1010_1010;
            b_in = 8'b0101_0101;


            #1;



            check_outputs(8'h01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed bits check", test_num);
            a_in = 8'hF0;
            b_in = 8'h0F;


            #1;



            check_outputs(8'h01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_operation Testbench");
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
        input [7:0] expected_out;
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
