`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg m_axis_tready;
    reg s_axis_aclk;
    reg s_axis_aresetn;
    reg [39:0] s_axis_tdata;
    reg s_axis_tvalid;
    wire [31:0] axis_data_count;
    wire [31:0] axis_rd_data_count;
    wire [31:0] axis_wr_data_count;
    wire [39:0] m_axis_tdata;
    wire m_axis_tvalid;
    wire s_axis_tready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .m_axis_tready(m_axis_tready),
        .s_axis_aclk(s_axis_aclk),
        .s_axis_aresetn(s_axis_aresetn),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .axis_data_count(axis_data_count),
        .axis_rd_data_count(axis_rd_data_count),
        .axis_wr_data_count(axis_wr_data_count),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid),
        .s_axis_tready(s_axis_tready)
    );

    // Clock generation (10ns period)
    initial begin
        s_axis_aclk = 0;
        forever #5 s_axis_aclk = ~s_axis_aclk;
    end

        task reset_dut;

        begin
            s_axis_aresetn = 0;
            s_axis_tvalid = 0;
            s_axis_tdata = 0;
            m_axis_tready = 0;
            @(posedge s_axis_aclk);
            #1 s_axis_aresetn = 1;
            @(posedge s_axis_aclk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();


            #1;



            check_outputs(32'd0, 32'd0, 32'd0, m_axis_tdata, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write", test_num);
            reset_dut();

            @(posedge s_axis_aclk);
            s_axis_tvalid = 1;
            s_axis_tdata = 40'hAAAAABBBBB;
            @(posedge s_axis_aclk);
            while(!s_axis_tready) @(posedge s_axis_aclk);
            s_axis_tvalid = 0;


            repeat(2) @(posedge s_axis_aclk);


            #1;



            check_outputs(32'd1, 32'd1, 32'd1, 40'hAAAAABBBBB, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Fill to Capacity (1024)", test_num);
            reset_dut();

            for (i = 0; i < 1024; i = i + 1) begin
                @(posedge s_axis_aclk);
                s_axis_tvalid = 1;
                s_axis_tdata = i[39:0];

                while(!s_axis_tready) @(posedge s_axis_aclk);
            end
            @(posedge s_axis_aclk);
            s_axis_tvalid = 0;

            repeat(2) @(posedge s_axis_aclk);



            #1;




            check_outputs(32'd1024, 32'd1024, 32'd1024, 40'd0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Burst Write and Read Back", test_num);
            reset_dut();


            for (i = 1; i <= 10; i = i + 1) begin
                @(posedge s_axis_aclk);
                s_axis_tvalid = 1;
                s_axis_tdata = i[39:0];
                while(!s_axis_tready) @(posedge s_axis_aclk);
            end
            @(posedge s_axis_aclk);
            s_axis_tvalid = 0;


            for (i = 1; i <= 10; i = i + 1) begin
                @(posedge s_axis_aclk);
                m_axis_tready = 1;
                while(!m_axis_tvalid) @(posedge s_axis_aclk);
            end
            @(posedge s_axis_aclk);
            m_axis_tready = 0;

            repeat(2) @(posedge s_axis_aclk);



            #1;




            check_outputs(32'd0, 32'd0, 32'd0, m_axis_tdata, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            for (i = 1; i <= 5; i = i + 1) begin
                @(posedge s_axis_aclk);
                s_axis_tvalid = 1;
                s_axis_tdata = i[39:0];
                while(!s_axis_tready) @(posedge s_axis_aclk);
            end


            for (i = 6; i <= 15; i = i + 1) begin
                @(posedge s_axis_aclk);
                s_axis_tvalid = 1;
                s_axis_tdata = i[39:0];
                m_axis_tready = 1;
            end
            @(posedge s_axis_aclk);
            s_axis_tvalid = 0;
            m_axis_tready = 0;

            repeat(2) @(posedge s_axis_aclk);


            #1;



            check_outputs(32'd5, 32'd5, 32'd5, m_axis_tdata, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reading Empty FIFO", test_num);
            reset_dut();

            @(posedge s_axis_aclk);
            m_axis_tready = 1;
            repeat(5) @(posedge s_axis_aclk);
            m_axis_tready = 0;


            #1;



            check_outputs(32'd0, 32'd0, 32'd0, m_axis_tdata, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Testcase %0d: Writing Full FIFO", test_num);
            reset_dut();


            for (i = 0; i < 1024; i = i + 1) begin
                @(posedge s_axis_aclk);
                s_axis_tvalid = 1;
                s_axis_tdata = 40'hF0F0F0F0F0;
                while(!s_axis_tready) @(posedge s_axis_aclk);
            end


            for (i = 0; i < 5; i = i + 1) begin
                @(posedge s_axis_aclk);
                s_axis_tvalid = 1;
                s_axis_tdata = 40'hFFFFFFFFFF;
            end
            @(posedge s_axis_aclk);
            s_axis_tvalid = 0;

            repeat(2) @(posedge s_axis_aclk);


            #1;



            check_outputs(32'd1024, 32'd1024, 32'd1024, 40'hF0F0F0F0F0, 1'b1, 1'b0);
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
        input [31:0] expected_axis_data_count;
        input [31:0] expected_axis_rd_data_count;
        input [31:0] expected_axis_wr_data_count;
        input [39:0] expected_m_axis_tdata;
        input expected_m_axis_tvalid;
        input expected_s_axis_tready;
        begin
            if (expected_axis_data_count === (expected_axis_data_count ^ axis_data_count ^ expected_axis_data_count) &&
                expected_axis_rd_data_count === (expected_axis_rd_data_count ^ axis_rd_data_count ^ expected_axis_rd_data_count) &&
                expected_axis_wr_data_count === (expected_axis_wr_data_count ^ axis_wr_data_count ^ expected_axis_wr_data_count) &&
                expected_m_axis_tdata === (expected_m_axis_tdata ^ m_axis_tdata ^ expected_m_axis_tdata) &&
                expected_m_axis_tvalid === (expected_m_axis_tvalid ^ m_axis_tvalid ^ expected_m_axis_tvalid) &&
                expected_s_axis_tready === (expected_s_axis_tready ^ s_axis_tready ^ expected_s_axis_tready)) begin
                $display("PASS");
                $display("  Outputs: axis_data_count=%h, axis_rd_data_count=%h, axis_wr_data_count=%h, m_axis_tdata=%h, m_axis_tvalid=%b, s_axis_tready=%b",
                         axis_data_count, axis_rd_data_count, axis_wr_data_count, m_axis_tdata, m_axis_tvalid, s_axis_tready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: axis_data_count=%h, axis_rd_data_count=%h, axis_wr_data_count=%h, m_axis_tdata=%h, m_axis_tvalid=%b, s_axis_tready=%b",
                         expected_axis_data_count, expected_axis_rd_data_count, expected_axis_wr_data_count, expected_m_axis_tdata, expected_m_axis_tvalid, expected_s_axis_tready);
                $display("  Got:      axis_data_count=%h, axis_rd_data_count=%h, axis_wr_data_count=%h, m_axis_tdata=%h, m_axis_tvalid=%b, s_axis_tready=%b",
                         axis_data_count, axis_rd_data_count, axis_wr_data_count, m_axis_tdata, m_axis_tvalid, s_axis_tready);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,m_axis_tready, s_axis_aclk, s_axis_aresetn, s_axis_tdata, s_axis_tvalid, axis_data_count, axis_rd_data_count, axis_wr_data_count, m_axis_tdata, m_axis_tvalid, s_axis_tready);
    end

endmodule
