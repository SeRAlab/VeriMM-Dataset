`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Fz;
    reg [3:0] X;
    reg [3:0] Y;
    reg [3:0] Z;
    reg rst;
    reg rw;
    wire [31:0] Fx;
    wire [31:0] Fy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Fz(Fz),
        .X(X),
        .Y(Y),
        .Z(Z),
        .rst(rst),
        .rw(rw),
        .Fx(Fx),
        .Fy(Fy)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset check (verify registers are zeroed)", test_num);
            rst = 1;
            rw = 0;
            X = 0;
            Y = 1;
            Fz = 0;
            Z = 0;
            #10;
            rst = 0;
            #10;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Write and Read (Register 2)", test_num);
            rst = 1; #10; rst = 0; #10;


            rw = 1;
            Z = 2;
            Fz = 32'hDEADBEEF;
            #10;
            rw = 0;


            X = 2;
            Y = 0;
            #10;
            #1;

            check_outputs(32'hDEADBEEF, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Write to multiple registers and verify", test_num);
            rst = 1; #10; rst = 0; #10;


            rw = 1; Z = 5; Fz = 32'h12345678; #10;

            rw = 1; Z = 10; Fz = 32'h87654321; #10;
            rw = 0;


            X = 5;
            Y = 10;
            #10;
            #1;

            check_outputs(32'h12345678, 32'h87654321);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Verify Write Enable (rw) control", test_num);
            rst = 1; #10; rst = 0; #10;


            rw = 0;
            Z = 7;
            Fz = 32'hFFFFFFFF;
            #10;


            X = 7;
            Y = 0;
            #10;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Overwrite an existing value", test_num);
            rst = 1; #10; rst = 0; #10;


            rw = 1; Z = 3; Fz = 32'hAAAA_AAAA; #10;

            rw = 1; Z = 3; Fz = 32'h5555_5555; #10;
            rw = 0;

            X = 3;
            Y = 3;
            #10;
            #1;

            check_outputs(32'h5555_5555, 32'h5555_5555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Boundary check (Registers 0 and 15)", test_num);
            rst = 1; #10; rst = 0; #10;


            rw = 1; Z = 0; Fz = 32'h0000_0001; #10;
            rw = 1; Z = 15; Fz = 32'h8000_0000; #10;
            rw = 0;

            X = 0;
            Y = 15;
            #10;
            #1;

            check_outputs(32'h0000_0001, 32'h8000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Verify Reset during operation", test_num);
            rst = 1; #10; rst = 0; #10;


            rw = 1; Z = 8; Fz = 32'h11223344; #10;
            rw = 0;


            rst = 1;
            #10;
            rst = 0;
            #10;

            X = 8;
            Y = 0;
            #10;
            #1;

            check_outputs(32'h0, 32'h0);
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
        input [31:0] expected_Fx;
        input [31:0] expected_Fy;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Fx === (expected_Fx ^ Fx ^ expected_Fx) &&
                expected_Fy === (expected_Fy ^ Fy ^ expected_Fy)) begin
                $display("PASS");
                $display("  Outputs: Fx=%h, Fy=%h",
                         Fx, Fy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Fx=%h, Fy=%h",
                         expected_Fx, expected_Fy);
                $display("  Got:      Fx=%h, Fy=%h",
                         Fx, Fy);
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
