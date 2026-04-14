`timescale 1ns/1ps

module pixel_inverter_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] pixel_input;
    wire [2:0] pixel_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pixel_inverter dut (
        .pixel_input(pixel_input),
        .pixel_output(pixel_output)
    );
    task testcase001;

        begin
            test_num = 1;
            pixel_input = 3'b000;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            pixel_input = 3'b001;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            pixel_input = 3'b010;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            pixel_input = 3'b011;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            pixel_input = 3'b100;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            pixel_input = 3'b101;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            pixel_input = 3'b110;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            pixel_input = 3'b111;
            #1;

            check_outputs(3'b000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pixel_inverter Testbench");
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
        input [2:0] expected_pixel_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pixel_output === (expected_pixel_output ^ pixel_output ^ expected_pixel_output)) begin
                $display("PASS");
                $display("  Outputs: pixel_output=%h",
                         pixel_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixel_output=%h",
                         expected_pixel_output);
                $display("  Got:      pixel_output=%h",
                         pixel_output);
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
