`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] P0;
    reg [7:0] P1;
    reg [7:0] P2;
    reg [7:0] P3;
    reg [7:0] X_frac;
    reg [7:0] Y_frac;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bilinear_interpolation dut (
        .P0(P0),
        .P1(P1),
        .P2(P2),
        .P3(P3),
        .X_frac(X_frac),
        .Y_frac(Y_frac),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All pixels same (0xFF)", test_num);
            P0 = 8'hFF; P1 = 8'hFF; P2 = 8'hFF; P3 = 8'hFF;
            X_frac = 8'h00; Y_frac = 8'h00;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Top-Left Corner (u=0, v=0)", test_num);
            P0 = 8'hAA; P1 = 8'h00; P2 = 8'h00; P3 = 8'h00;
            X_frac = 8'h00; Y_frac = 8'h00;
            #1;

            check_outputs(16'hAA00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Integer bits check (X_frac=0xF0, Y_frac=0xF0)", test_num);
            P0 = 8'h55; P1 = 8'h00; P2 = 8'h00; P3 = 8'h00;
            X_frac = 8'hF0; Y_frac = 8'hF0;
            #1;

            check_outputs(16'h5500);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-point horizontal (u=8, v=0)", test_num);
            P0 = 8'd100; P1 = 8'd200; P2 = 8'd0; P3 = 8'd0;
            X_frac = 8'h08; Y_frac = 8'h00;


            #1;



            check_outputs(16'h9600);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-point vertical (u=0, v=8)", test_num);
            P0 = 8'd40; P1 = 8'd0; P2 = 8'd60; P3 = 8'd0;
            X_frac = 8'h00; Y_frac = 8'h08;


            #1;



            check_outputs(16'h3200);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bottom-Right Corner (u=15, v=15)", test_num);
            P0 = 8'h00; P1 = 8'h00; P2 = 8'h00; P3 = 8'd255;
            X_frac = 8'h0F; Y_frac = 8'h0F;


            #1;



            check_outputs(16'hE01F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: General interpolation", test_num);
            P0 = 8'd10; P1 = 8'd20; P2 = 8'd30; P3 = 8'd40;
            X_frac = 8'h04; Y_frac = 8'h04;



            #1;




            check_outputs(16'h1180);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bilinear_interpolation Testbench");
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
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
