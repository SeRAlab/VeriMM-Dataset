`timescale 1ns/1ps

module bw_r_irf_72_4x1_mux_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] sel;
    reg [71:0] x0;
    reg [71:0] x1;
    reg [71:0] x2;
    reg [71:0] x3;
    wire [71:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bw_r_irf_72_4x1_mux dut (
        .sel(sel),
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select x0", test_num);
            sel = 2'b00;
            x0 = 72'hAAAA_BBBB_CCCC_DDDD_EE;
            x1 = 72'h0000_1111_2222_3333_44;
            x2 = 72'h5555_6666_7777_8888_99;
            x3 = 72'hEEEE_FFFF_0000_1111_22;
            #1;

            check_outputs(72'hAAAA_BBBB_CCCC_DDDD_EE);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select x1", test_num);
            sel = 2'b01;
            x0 = 72'hAAAA_BBBB_CCCC_DDDD_EE;
            x1 = 72'h0000_1111_2222_3333_44;
            x2 = 72'h5555_6666_7777_8888_99;
            x3 = 72'hEEEE_FFFF_0000_1111_22;
            #1;

            check_outputs(72'h0000_1111_2222_3333_44);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select x2", test_num);
            sel = 2'b10;
            x0 = 72'hAAAA_BBBB_CCCC_DDDD_EE;
            x1 = 72'h0000_1111_2222_3333_44;
            x2 = 72'h5555_6666_7777_8888_99;
            x3 = 72'hEEEE_FFFF_0000_1111_22;
            #1;

            check_outputs(72'h5555_6666_7777_8888_99);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select x3", test_num);
            sel = 2'b11;
            x0 = 72'hAAAA_BBBB_CCCC_DDDD_EE;
            x1 = 72'h0000_1111_2222_3333_44;
            x2 = 72'h5555_6666_7777_8888_99;
            x3 = 72'hEEEE_FFFF_0000_1111_22;
            #1;

            check_outputs(72'hEEEE_FFFF_0000_1111_22);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones on select x0", test_num);
            sel = 2'b00;
            x0 = {72{1'b1}};
            x1 = {72{1'b0}};
            x2 = {72{1'b0}};
            x3 = {72{1'b0}};
            #1;

            check_outputs({72{1'b1}});
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros on select x3", test_num);
            sel = 2'b11;
            x0 = {72{1'b1}};
            x1 = {72{1'b1}};
            x2 = {72{1'b1}};
            x3 = {72{1'b0}};
            #1;

            check_outputs({72{1'b0}});
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits on select x1", test_num);
            sel = 2'b01;
            x0 = 72'h0;
            x1 = 72'h5555_5555_5555_5555_55;
            x2 = 72'hAAAA_AAAA_AAAA_AAAA_AA;
            x3 = 72'hFFFF_FFFF_FFFF_FFFF_FF;
            #1;

            check_outputs(72'h5555_5555_5555_5555_55);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits on select x2", test_num);
            sel = 2'b10;
            x0 = 72'h0;
            x1 = 72'h5555_5555_5555_5555_55;
            x2 = 72'hAAAA_AAAA_AAAA_AAAA_AA;
            x3 = 72'hFFFF_FFFF_FFFF_FFFF_FF;
            #1;

            check_outputs(72'hAAAA_AAAA_AAAA_AAAA_AA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bw_r_irf_72_4x1_mux Testbench");
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
        input [71:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
