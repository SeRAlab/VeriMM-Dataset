`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] HC;
    reg [17:0] SW;
    reg [9:0] VC;
    reg VIDON;
    wire [7:0] B;
    wire [7:0] G;
    wire [7:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .HC(HC),
        .SW(SW),
        .VC(VC),
        .VIDON(VIDON),
        .B(B),
        .G(G),
        .R(R)
    );
    task testcase001;

        begin
            test_num = 1;
            VIDON = 0;
            SW = 18'h0;
            VC = 450;
            HC = 0;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            VIDON = 1;
            SW = 18'h0;
            VC = 450;
            HC = 100;
            #1;

            check_outputs(8'hFF, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            VIDON = 1;
            SW = 18'h0;
            VC = 350;
            HC = 100;

            #1;


            check_outputs(8'h00, 8'hFF, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            VIDON = 1;
            SW = 18'h0;
            VC = 250;
            HC = 100;
            #1;

            check_outputs(8'h00, 8'h00, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            VIDON = 1;
            SW = 18'h0;
            VC = 150;
            HC = 100;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            VIDON = 1;
            SW = 18'b111111_000000_111111;
            VC = 450;
            HC = 100;


            #1;



            check_outputs(8'hFC, 8'h00, 8'hFC);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            VIDON = 1;
            SW = 18'b010101_101010_011011;
            VC = 100;
            HC = 100;

            #1;


            check_outputs(8'h54, 8'hA8, 8'h6C);
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
        input [7:0] expected_B;
        input [7:0] expected_G;
        input [7:0] expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B === (expected_B ^ B ^ expected_B) &&
                expected_G === (expected_G ^ G ^ expected_G) &&
                expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: B=%h, G=%h, R=%h",
                         B, G, R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%h, G=%h, R=%h",
                         expected_B, expected_G, expected_R);
                $display("  Got:      B=%h, G=%h, R=%h",
                         B, G, R);
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
