`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg aclk;
    reg [23:0] s_axis_cartesian_tdata;
    reg s_axis_cartesian_tvalid;
    wire [15:0] m_axis_dout_tdata;
    wire m_axis_dout_tvalid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aclk(aclk),
        .s_axis_cartesian_tdata(s_axis_cartesian_tdata),
        .s_axis_cartesian_tvalid(s_axis_cartesian_tvalid),
        .m_axis_dout_tdata(m_axis_dout_tdata),
        .m_axis_dout_tvalid(m_axis_dout_tvalid)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: (X=3, Y=4) -> Expected=5", test_num);

        s_axis_cartesian_tvalid = 0;
        s_axis_cartesian_tdata = 0;
        repeat(5) @(posedge aclk);


        s_axis_cartesian_tdata = {12'd4, 12'd3};
        s_axis_cartesian_tvalid = 1;
        @(posedge aclk);
        s_axis_cartesian_tvalid = 0;


        while (!m_axis_dout_tvalid) @(posedge aclk);
        #1;

        check_outputs(16'd5, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: (X=0, Y=0) -> Expected=0", test_num);
        s_axis_cartesian_tvalid = 0;
        s_axis_cartesian_tdata = 0;
        repeat(5) @(posedge aclk);

        s_axis_cartesian_tdata = {12'd0, 12'd0};
        s_axis_cartesian_tvalid = 1;
        @(posedge aclk);
        s_axis_cartesian_tvalid = 0;

        while (!m_axis_dout_tvalid) @(posedge aclk);
        #1;

        check_outputs(16'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: (X=100, Y=0) -> Expected=100", test_num);
        s_axis_cartesian_tvalid = 0;
        repeat(5) @(posedge aclk);

        s_axis_cartesian_tdata = {12'd0, 12'd100};
        s_axis_cartesian_tvalid = 1;
        @(posedge aclk);
        s_axis_cartesian_tvalid = 0;

        while (!m_axis_dout_tvalid) @(posedge aclk);
        #1;

        check_outputs(16'd100, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: (X=5, Y=12) -> Expected=13", test_num);
        s_axis_cartesian_tvalid = 0;
        repeat(5) @(posedge aclk);

        s_axis_cartesian_tdata = {12'd12, 12'd5};
        s_axis_cartesian_tvalid = 1;
        @(posedge aclk);
        s_axis_cartesian_tvalid = 0;

        while (!m_axis_dout_tvalid) @(posedge aclk);
        #1;

        check_outputs(16'd13, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %0d: (X=20, Y=21) -> Expected=29", test_num);
        s_axis_cartesian_tvalid = 0;
        repeat(5) @(posedge aclk);

        s_axis_cartesian_tdata = {12'd21, 12'd20};
        s_axis_cartesian_tvalid = 1;
        @(posedge aclk);
        s_axis_cartesian_tvalid = 0;

        while (!m_axis_dout_tvalid) @(posedge aclk);
        #1;

        check_outputs(16'd29, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase %0d: (X=-8, Y=-15) -> Expected=17", test_num);
        s_axis_cartesian_tvalid = 0;
        repeat(5) @(posedge aclk);


        s_axis_cartesian_tdata = {12'hFF1, 12'hFF8};
        s_axis_cartesian_tvalid = 1;
        @(posedge aclk);
        s_axis_cartesian_tvalid = 0;

        while (!m_axis_dout_tvalid) @(posedge aclk);
        #1;

        check_outputs(16'd17, 1'b1);
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
        input [15:0] expected_m_axis_dout_tdata;
        input expected_m_axis_dout_tvalid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_m_axis_dout_tdata === (expected_m_axis_dout_tdata ^ m_axis_dout_tdata ^ expected_m_axis_dout_tdata) &&
                expected_m_axis_dout_tvalid === (expected_m_axis_dout_tvalid ^ m_axis_dout_tvalid ^ expected_m_axis_dout_tvalid)) begin
                $display("PASS");
                $display("  Outputs: m_axis_dout_tdata=%h, m_axis_dout_tvalid=%b",
                         m_axis_dout_tdata, m_axis_dout_tvalid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_axis_dout_tdata=%h, m_axis_dout_tvalid=%b",
                         expected_m_axis_dout_tdata, expected_m_axis_dout_tvalid);
                $display("  Got:      m_axis_dout_tdata=%h, m_axis_dout_tvalid=%b",
                         m_axis_dout_tdata, m_axis_dout_tvalid);
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
