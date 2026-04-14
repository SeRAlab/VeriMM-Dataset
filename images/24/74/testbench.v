`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] EX_dest;
    reg EX_valid;
    reg [4:0] MEM_dest;
    reg MEM_valid;
    reg [4:0] WB_dest;
    reg WB_valid;
    wire ForwardA;
    wire ForwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .EX_dest(EX_dest),
        .EX_valid(EX_valid),
        .MEM_dest(MEM_dest),
        .MEM_valid(MEM_valid),
        .WB_dest(WB_dest),
        .WB_valid(WB_valid),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: All inputs zero", test_num);
            EX_dest = 5'd0; EX_valid = 1'b0;
            MEM_dest = 5'd0; MEM_valid = 1'b0;
            WB_dest = 5'd0; WB_valid = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Different registers (No Hazard)", test_num);
            EX_dest = 5'd1; EX_valid = 1'b1;
            MEM_dest = 5'd2; MEM_valid = 1'b1;
            WB_dest = 5'd3; WB_valid = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Hazard with MEM stage (ForwardA)", test_num);
            EX_dest = 5'd10; EX_valid = 1'b1;
            MEM_dest = 5'd10; MEM_valid = 1'b1;
            WB_dest = 5'd5; WB_valid = 1'b1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Hazard with WB stage (ForwardB)", test_num);
            EX_dest = 5'd15; EX_valid = 1'b1;
            MEM_dest = 5'd2; MEM_valid = 1'b1;
            WB_dest = 5'd15; WB_valid = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Hazard with both MEM and WB stages", test_num);
            EX_dest = 5'd7; EX_valid = 1'b1;
            MEM_dest = 5'd7; MEM_valid = 1'b1;
            WB_dest = 5'd7; WB_valid = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Match with MEM but MEM_valid is low", test_num);
            EX_dest = 5'd20; EX_valid = 1'b1;
            MEM_dest = 5'd20; MEM_valid = 1'b0;
            WB_dest = 5'd5; WB_valid = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Match with WB but WB_valid is low", test_num);
            EX_dest = 5'd25; EX_valid = 1'b1;
            MEM_dest = 5'd2; MEM_valid = 1'b1;
            WB_dest = 5'd25; WB_valid = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Matching Register 0 (Should not forward)", test_num);
            EX_dest = 5'd0; EX_valid = 1'b1;
            MEM_dest = 5'd0; MEM_valid = 1'b1;
            WB_dest = 5'd0; WB_valid = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Matching registers but EX stage invalid", test_num);
            EX_dest = 5'd4; EX_valid = 1'b0;
            MEM_dest = 5'd4; MEM_valid = 1'b1;
            WB_dest = 5'd4; WB_valid = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_forwarding_unit Testbench");
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
        input expected_ForwardA;
        input expected_ForwardB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ForwardA === (expected_ForwardA ^ ForwardA ^ expected_ForwardA) &&
                expected_ForwardB === (expected_ForwardB ^ ForwardB ^ expected_ForwardB)) begin
                $display("PASS");
                $display("  Outputs: ForwardA=%b, ForwardB=%b",
                         ForwardA, ForwardB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ForwardA=%b, ForwardB=%b",
                         expected_ForwardA, expected_ForwardB);
                $display("  Got:      ForwardA=%b, ForwardB=%b",
                         ForwardA, ForwardB);
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
