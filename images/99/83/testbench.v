`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EX_ramtoreg;
    reg [4:0] EX_rt;
    reg [4:0] ID_rs;
    reg [4:0] ID_rt;
    wire load_use_hazard;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_ramtoreg(EX_ramtoreg),
        .EX_rt(EX_rt),
        .ID_rs(ID_rs),
        .ID_rt(ID_rt),
        .load_use_hazard(load_use_hazard)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No Hazard - EX_ramtoreg is 0 (not a load)", test_num);
            ID_rs = 5'd1;
            ID_rt = 5'd2;
            EX_rt = 5'd1;
            EX_ramtoreg = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No Hazard - EX_rt is zero register", test_num);
            ID_rs = 5'd0;
            ID_rt = 5'd0;
            EX_rt = 5'd0;
            EX_ramtoreg = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard Detected - EX_rt matches ID_rs", test_num);
            ID_rs = 5'd10;
            ID_rt = 5'd11;
            EX_rt = 5'd10;
            EX_ramtoreg = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard Detected - EX_rt matches ID_rt", test_num);
            ID_rs = 5'd10;
            ID_rt = 5'd11;
            EX_rt = 5'd11;
            EX_ramtoreg = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No Hazard - No register matches", test_num);
            ID_rs = 5'd1;
            ID_rt = 5'd2;
            EX_rt = 5'd3;
            EX_ramtoreg = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard Detected - Both ID_rs and ID_rt match EX_rt", test_num);
            ID_rs = 5'd15;
            ID_rt = 5'd15;
            EX_rt = 5'd15;
            EX_ramtoreg = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No Hazard - Max register value but ramtoreg is 0", test_num);
            ID_rs = 5'd31;
            ID_rt = 5'd31;
            EX_rt = 5'd31;
            EX_ramtoreg = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No Hazard - ID_rs matches EX_rt but EX_rt is 0", test_num);
            ID_rs = 5'd0;
            ID_rt = 5'd5;
            EX_rt = 5'd0;
            EX_ramtoreg = 1'b1;
            #1;

            check_outputs(1'b0);
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
        input expected_load_use_hazard;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_load_use_hazard === (expected_load_use_hazard ^ load_use_hazard ^ expected_load_use_hazard)) begin
                $display("PASS");
                $display("  Outputs: load_use_hazard=%b",
                         load_use_hazard);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: load_use_hazard=%b",
                         expected_load_use_hazard);
                $display("  Got:      load_use_hazard=%b",
                         load_use_hazard);
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
