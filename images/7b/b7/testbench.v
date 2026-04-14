`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [3:0] d;
    reg [3:0] t;
    wire D;
    wire T;
    wire [2:0] cout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .d(d),
        .t(t),
        .D(D),
        .T(T),
        .cout(cout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            cin = 0; d = 4'b0000; t = 4'b0000;
            #1;

            check_outputs(1'b0, 1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: cin propagation only through bit 0", test_num);
            cin = 1; d = 4'b0000; t = 4'b0001;



            #1;




            check_outputs(1'b0, 1'b0, 3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: cin propagation through all cout bits", test_num);
            cin = 1; d = 4'b0000; t = 4'b0111;



            #1;




            check_outputs(1'b0, 1'b0, 3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full propagation T=1, cin=1", test_num);
            cin = 1; d = 4'b0000; t = 4'b1111;

            #1;


            check_outputs(1'b0, 1'b1, 3'b111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry generation D=1 from MSB bit", test_num);
            cin = 0; d = 4'b1000; t = 4'b0000;


            #1;



            check_outputs(1'b1, 1'b0, 3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry generation from bit 0 propagating to D", test_num);
            cin = 0; d = 4'b0001; t = 4'b1110;




            #1;





            check_outputs(1'b1, 1'b0, 3'b111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed generate and propagate", test_num);
            cin = 1; d = 4'b0101; t = 4'b1010;





            #1;






            check_outputs(1'b1, 1'b0, 3'b111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: cin blocked by t=0", test_num);
            cin = 1; d = 4'b0000; t = 4'b1110;


            #1;



            check_outputs(1'b0, 1'b0, 3'b000);
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
        input expected_D;
        input expected_T;
        input [2:0] expected_cout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_T === (expected_T ^ T ^ expected_T) &&
                expected_cout === (expected_cout ^ cout ^ expected_cout)) begin
                $display("PASS");
                $display("  Outputs: D=%b, T=%b, cout=%h",
                         D, T, cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%b, T=%b, cout=%h",
                         expected_D, expected_T, expected_cout);
                $display("  Got:      D=%b, T=%b, cout=%h",
                         D, T, cout);
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
