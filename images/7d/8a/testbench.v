`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] GColor;
    reg VColor;
    reg mode;
    wire VGA_B;
    wire VGA_G;
    wire VGA_R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .GColor(GColor),
        .VColor(VColor),
        .mode(mode),
        .VGA_B(VGA_B),
        .VGA_G(VGA_G),
        .VGA_R(VGA_R)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mode=0, VColor=0 (Mono Black)", test_num);
            mode = 1'b0;
            VColor = 1'b0;
            GColor = 3'b111;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mode=0, VColor=1 (Mono White)", test_num);
            mode = 1'b0;
            VColor = 1'b1;
            GColor = 3'b000;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mode=1, GColor=100 (Red Only)", test_num);
            mode = 1'b1;
            VColor = 1'b0;
            GColor = 3'b100;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mode=1, GColor=010 (Green Only)", test_num);
            mode = 1'b1;
            VColor = 1'b1;
            GColor = 3'b010;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mode=1, GColor=001 (Blue Only)", test_num);
            mode = 1'b1;
            GColor = 3'b001;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mode=1, GColor=110 (Yellow)", test_num);
            mode = 1'b1;
            GColor = 3'b110;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mode=1, GColor=101 (Magenta)", test_num);
            mode = 1'b1;
            GColor = 3'b101;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mode=1, GColor=011 (Cyan)", test_num);
            mode = 1'b1;
            GColor = 3'b011;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mode=1, GColor=000 (Black)", test_num);
            mode = 1'b1;
            GColor = 3'b000;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mode=1, GColor=111 (White)", test_num);
            mode = 1'b1;
            GColor = 3'b111;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
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
        input expected_VGA_B;
        input expected_VGA_G;
        input expected_VGA_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_VGA_B === (expected_VGA_B ^ VGA_B ^ expected_VGA_B) &&
                expected_VGA_G === (expected_VGA_G ^ VGA_G ^ expected_VGA_G) &&
                expected_VGA_R === (expected_VGA_R ^ VGA_R ^ expected_VGA_R)) begin
                $display("PASS");
                $display("  Outputs: VGA_B=%b, VGA_G=%b, VGA_R=%b",
                         VGA_B, VGA_G, VGA_R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VGA_B=%b, VGA_G=%b, VGA_R=%b",
                         expected_VGA_B, expected_VGA_G, expected_VGA_R);
                $display("  Got:      VGA_B=%b, VGA_G=%b, VGA_R=%b",
                         VGA_B, VGA_G, VGA_R);
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
