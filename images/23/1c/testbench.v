`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] forward_sel;
    reg [31:0] rs1;
    reg [31:0] rs2;
    wire [31:0] forwarded_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .forward_sel(forward_sel),
        .rs1(rs1),
        .rs2(rs2),
        .forwarded_data(forwarded_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: forward_sel = 00 (Select rs1)", test_num);
            rs1 = 32'hAAAA_AAAA;
            rs2 = 32'h5555_5555;
            forward_sel = 2'b00;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: forward_sel = 01 (Select rs2)", test_num);
            rs1 = 32'h1234_5678;
            rs2 = 32'h8765_4321;
            forward_sel = 2'b01;
            #1;

            check_outputs(32'h8765_4321);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: forward_sel = 10 (Select rs1 - latest)", test_num);
            rs1 = 32'hFFFF_FFFF;
            rs2 = 32'h0000_0000;
            forward_sel = 2'b10;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: forward_sel = 11 (Select rs2 - latest)", test_num);
            rs1 = 32'hDEAD_BEEF;
            rs2 = 32'hCAFE_BABE;
            forward_sel = 2'b11;
            #1;

            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check selection with all zeros", test_num);
            rs1 = 32'h0000_0000;
            rs2 = 32'hFFFF_FFFF;
            forward_sel = 2'b00;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check selection with alternating patterns", test_num);
            rs1 = 32'h5A5A_5A5A;
            rs2 = 32'hA5A5_A5A5;
            forward_sel = 2'b01;
            #1;

            check_outputs(32'hA5A5_A5A5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify rs1 forwarding (10) with large value", test_num);
            rs1 = 32'hF0F0_F0F0;
            rs2 = 32'h0F0F_0F0F;
            forward_sel = 2'b10;
            #1;

            check_outputs(32'hF0F0_F0F0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify rs2 forwarding (11) with large value", test_num);
            rs1 = 32'hCCCC_CCCC;
            rs2 = 32'h3333_3333;
            forward_sel = 2'b11;
            #1;

            check_outputs(32'h3333_3333);
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
        input [31:0] expected_forwarded_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forwarded_data === (expected_forwarded_data ^ forwarded_data ^ expected_forwarded_data)) begin
                $display("PASS");
                $display("  Outputs: forwarded_data=%h",
                         forwarded_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forwarded_data=%h",
                         expected_forwarded_data);
                $display("  Got:      forwarded_data=%h",
                         forwarded_data);
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
