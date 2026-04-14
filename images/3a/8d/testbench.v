`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dest;
    reg forward_sel;
    reg [4:0] src1;
    reg [4:0] src2;
    wire [4:0] forward_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .dest(dest),
        .forward_sel(forward_sel),
        .src1(src1),
        .src2(src2),
        .forward_data(forward_data)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Forwarding Disabled (forward_sel=0)", test_num);
        src1 = 5'h0A;
        src2 = 5'h15;
        dest = 5'h1F;
        forward_sel = 1'b0;
        #1;

        check_outputs(5'h0A);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Forwarding Enabled (forward_sel=1)", test_num);
        src1 = 5'h0A;
        src2 = 5'h15;
        dest = 5'h1F;
        forward_sel = 1'b1;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify src2 isolation (forward_sel=0)", test_num);
        src1 = 5'h05;
        src2 = 5'h1E;
        dest = 5'h10;
        forward_sel = 1'b0;
        #1;

        check_outputs(5'h05);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify src1 isolation (forward_sel=1)", test_num);
        src1 = 5'h12;
        src2 = 5'h00;
        dest = 5'h07;
        forward_sel = 1'b1;
        #1;

        check_outputs(5'h07);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs zero", test_num);
        src1 = 5'b00000;
        src2 = 5'b00000;
        dest = 5'b00000;
        forward_sel = 1'b0;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs max (5'h1F)", test_num);
        src1 = 5'b11111;
        src2 = 5'b11111;
        dest = 5'b11111;
        forward_sel = 1'b1;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bit-wise integrity check (Alternating bits)", test_num);
        src1 = 5'b10101;
        src2 = 5'b01010;
        dest = 5'b11001;
        forward_sel = 1'b1;
        #1;

        check_outputs(5'b11001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pipeline Hazard Simulation (dest == src1)", test_num);
        src1 = 5'h04;
        src2 = 5'h08;
        dest = 5'h04;
        forward_sel = 1'b1;
        #1;

        check_outputs(5'h04);
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
        input [4:0] expected_forward_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forward_data === (expected_forward_data ^ forward_data ^ expected_forward_data)) begin
                $display("PASS");
                $display("  Outputs: forward_data=%h",
                         forward_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forward_data=%h",
                         expected_forward_data);
                $display("  Got:      forward_data=%h",
                         forward_data);
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
