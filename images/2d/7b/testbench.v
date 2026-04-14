`timescale 1ns/1ps

module dac_24bit_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] input_value;
    reg [11:0] reference_voltage;
    wire [31:0] v_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dac_24bit dut (
        .input_value(input_value),
        .reference_voltage(reference_voltage),
        .v_out(v_out)
    );
    task testcase001;

        begin
            test_num = 1;
            input_value = 24'h000000;
            reference_voltage = 12'h000;
            $display("Test %0d: All Zeros", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            input_value = 24'hFFFFFF;
            reference_voltage = 12'hFFF;
            $display("Test %0d: Maximum Scale (Full Input, Full Reference)", test_num);

            #1;


            check_outputs(32'hFFEFFF00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            input_value = 24'h800000;
            reference_voltage = 12'hFFF;
            $display("Test %0d: Mid-scale Input, Full Reference", test_num);

            #1;


            check_outputs(32'h7FF80000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            input_value = 24'hFFFFFF;
            reference_voltage = 12'h800;
            $display("Test %0d: Full Input, Mid-scale Reference", test_num);

            #1;


            check_outputs(32'h7FFFFF00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            input_value = 24'h800000;
            reference_voltage = 12'h800;
            $display("Test %0d: Mid-scale Input, Mid-scale Reference", test_num);

            #1;


            check_outputs(32'h40000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            input_value = 24'h000001;
            reference_voltage = 12'h010;
            $display("Test %0d: Minimum non-zero output step", test_num);

            #1;


            check_outputs(32'h00000001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            input_value = 24'h100000;
            reference_voltage = 12'h001;
            $display("Test %0d: Power of 2 scaling check", test_num);

            #1;


            check_outputs(32'h00010000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            input_value = 24'hAAAAAA;
            reference_voltage = 12'h555;
            $display("Test %0d: Arbitrary Pattern Check", test_num);

            #1;


            check_outputs(32'h38DFFFC7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dac_24bit Testbench");
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
        input [31:0] expected_v_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_v_out === (expected_v_out ^ v_out ^ expected_v_out)) begin
                $display("PASS");
                $display("  Outputs: v_out=%h",
                         v_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v_out=%h",
                         expected_v_out);
                $display("  Got:      v_out=%h",
                         v_out);
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
