`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [31:0] external_ip;
    reg [31:0] internal_ip;
    wire [31:0] translated_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .control(control),
        .external_ip(external_ip),
        .internal_ip(internal_ip),
        .translated_ip(translated_ip)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Control=0 (Translation Off)", test_num);
            internal_ip = 32'hC0A80101;
            external_ip = 32'h08080808;
            control = 1'b0;
            #1;

            check_outputs(32'hC0A80101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Control=1 (Translation On)", test_num);
            internal_ip = 32'hC0A80101;
            external_ip = 32'h08080808;
            control = 1'b1;
            #1;

            check_outputs(32'h08080808);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Control=0 with different IP values", test_num);
            internal_ip = 32'h0A000005;
            external_ip = 32'hD83AD38E;
            control = 1'b0;
            #1;

            check_outputs(32'h0A000005);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Control=1 with different IP values", test_num);
            internal_ip = 32'h0A000005;
            external_ip = 32'hD83AD38E;
            control = 1'b1;
            #1;

            check_outputs(32'hD83AD38E);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Boundary condition (All 0s)", test_num);
            internal_ip = 32'h00000000;
            external_ip = 32'hFFFFFFFF;
            control = 1'b0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Boundary condition (All 1s translation)", test_num);
            internal_ip = 32'h00000000;
            external_ip = 32'hFFFFFFFF;
            control = 1'b1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Toggle Control signal", test_num);
            internal_ip = 32'hDEADBEEF;
            external_ip = 32'hCAFEBABE;
            control = 1'b0;
            #5;
            control = 1'b1;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NAT Testbench");
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
        input [31:0] expected_translated_ip;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_translated_ip === (expected_translated_ip ^ translated_ip ^ expected_translated_ip)) begin
                $display("PASS");
                $display("  Outputs: translated_ip=%h",
                         translated_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: translated_ip=%h",
                         expected_translated_ip);
                $display("  Got:      translated_ip=%h",
                         translated_ip);
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
