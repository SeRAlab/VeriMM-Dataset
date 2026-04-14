`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] S0;
    reg [7:0] S1;
    reg [7:0] S2;
    reg [7:0] S3;
    reg [7:0] S4;
    reg [7:0] S5;
    reg [7:0] S6;
    reg [7:0] S7;
    reg [2:0] Sel;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .S0(S0),
        .S1(S1),
        .S2(S2),
        .S3(S3),
        .S4(S4),
        .S5(S5),
        .S6(S6),
        .S7(S7),
        .Sel(Sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select S0", test_num);
            S0 = 8'hA5; S1 = 8'h00; S2 = 8'h00; S3 = 8'h00;
            S4 = 8'h00; S5 = 8'h00; S6 = 8'h00; S7 = 8'h00;
            Sel = 3'b000;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select S1", test_num);
            S0 = 8'h00; S1 = 8'h5A; S2 = 8'h00; S3 = 8'h00;
            S4 = 8'h00; S5 = 8'h00; S6 = 8'h00; S7 = 8'h00;
            Sel = 3'b001;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select S2", test_num);
            S0 = 8'hFF; S1 = 8'hEE; S2 = 8'hDD; S3 = 8'hCC;
            S4 = 8'hBB; S5 = 8'hAA; S6 = 8'h99; S7 = 8'h88;
            Sel = 3'b010;
            #1;

            check_outputs(8'hDD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select S3", test_num);
            S3 = 8'h12;
            Sel = 3'b011;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Select S4", test_num);
            S4 = 8'h34;
            Sel = 3'b100;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Select S5", test_num);
            S5 = 8'h56;
            Sel = 3'b101;
            #1;

            check_outputs(8'h56);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Select S6", test_num);
            S6 = 8'h78;
            Sel = 3'b110;
            #1;

            check_outputs(8'h78);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Select S7", test_num);
            S7 = 8'h90;
            Sel = 3'b111;
            #1;

            check_outputs(8'h90);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: All inputs identical", test_num);
            S0 = 8'hFF; S1 = 8'hFF; S2 = 8'hFF; S3 = 8'hFF;
            S4 = 8'hFF; S5 = 8'hFF; S6 = 8'hFF; S7 = 8'hFF;
            Sel = 3'b101;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Change data while Sel is constant", test_num);
            Sel = 3'b000;
            S0 = 8'h11;
            #5;
            S0 = 8'h22;
            #1;

            check_outputs(8'h22);
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
