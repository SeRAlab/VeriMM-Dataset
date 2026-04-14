`timescale 1ns/1ps

module M65C02_BIN_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg Ci;
    reg En;
    wire OV;
    wire [8:0] Out;
    wire Valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    M65C02_BIN dut (
        .A(A),
        .B(B),
        .Ci(Ci),
        .En(En),
        .OV(OV),
        .Out(Out),
        .Valid(Valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Module Disabled (En=0)", test_num);
            En = 0; A = 8'hFF; B = 8'hFF; Ci = 1;
            #1;

            check_outputs(1'b0, 9'h000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Addition (No Carry, No Overflow)", test_num);
            En = 1; A = 8'h05; B = 8'h10; Ci = 0;

            #1;


            check_outputs(1'b0, 9'h015, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Carry-in", test_num);
            En = 1; A = 8'h05; B = 8'h10; Ci = 1;

            #1;


            check_outputs(1'b0, 9'h016, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry-out Generation (Unsigned > 255)", test_num);
            En = 1; A = 8'hF0; B = 8'h20; Ci = 0;

            #1;


            check_outputs(1'b0, 9'h110, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Overflow (127 + 1)", test_num);
            En = 1; A = 8'h7F; B = 8'h01; Ci = 0;


            #1;



            check_outputs(1'b1, 9'h080, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Overflow (-128 + -1)", test_num);
            En = 1; A = 8'h80; B = 8'hFF; Ci = 0;


            #1;



            check_outputs(1'b1, 9'h17F, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Addition (Max range, No Overflow)", test_num);
            En = 1; A = 8'hFF; B = 8'hFF; Ci = 1;


            #1;



            check_outputs(1'b0, 9'h1FF, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Addition", test_num);
            En = 1; A = 8'h00; B = 8'h00; Ci = 0;
            #1;

            check_outputs(1'b0, 9'h000, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed Sign Addition (No Overflow possible)", test_num);
            En = 1; A = 8'h7F; B = 8'h81; Ci = 0;


            #1;



            check_outputs(1'b0, 9'h100, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Toggle Check", test_num);
            En = 1; A = 8'h12; B = 8'h34; Ci = 0;
            #1;
            En = 0;

            #1;


            check_outputs(1'b0, 9'h000, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("M65C02_BIN Testbench");
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
        input expected_OV;
        input [8:0] expected_Out;
        input expected_Valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OV === (expected_OV ^ OV ^ expected_OV) &&
                expected_Out === (expected_Out ^ Out ^ expected_Out) &&
                expected_Valid === (expected_Valid ^ Valid ^ expected_Valid)) begin
                $display("PASS");
                $display("  Outputs: OV=%b, Out=%h, Valid=%b",
                         OV, Out, Valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OV=%b, Out=%h, Valid=%b",
                         expected_OV, expected_Out, expected_Valid);
                $display("  Got:      OV=%b, Out=%h, Valid=%b",
                         OV, Out, Valid);
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
