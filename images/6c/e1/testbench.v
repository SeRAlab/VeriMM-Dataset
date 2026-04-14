`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aclk;
    reg aresetn;
    reg m_axis_tready;
    reg [63:0] s_axis_tdata;
    reg s_axis_tvalid;
    wire [15:0] m_axis_tdata;
    wire m_axis_tvalid;
    wire s_axis_tready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aclk(aclk),
        .aresetn(aresetn),
        .m_axis_tready(m_axis_tready),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid),
        .s_axis_tready(s_axis_tready)
    );

    // Clock generation (10ns period)
    initial begin
        aclk = 0;
        forever #5 aclk = ~aclk;
    end

        task reset_dut;

        begin
            aresetn = 0;
            s_axis_tvalid = 0;
            s_axis_tdata = 0;
            m_axis_tready = 1;
            repeat(5) @(posedge aclk);
            aresetn = 1;
            @(posedge aclk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Pulse duration of 5 cycles");
            reset_dut();


            s_axis_tdata = 64'h0005_0000_0000_AAAA;
            s_axis_tvalid = 1;


            wait(s_axis_tready == 1);
            @(posedge aclk);
            s_axis_tvalid = 0;


            wait(m_axis_tvalid == 1);


            wait(m_axis_tvalid == 0);
            @(posedge aclk);



            #1;




            check_outputs(16'hAAAA, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Pulse duration of 1 cycle");
            reset_dut();

            s_axis_tdata = 64'h0001_0000_0000_5555;
            s_axis_tvalid = 1;

            wait(s_axis_tready == 1);
            @(posedge aclk);
            s_axis_tvalid = 0;

            wait(m_axis_tvalid == 1);
            wait(m_axis_tvalid == 0);
            @(posedge aclk);

            #1;


            check_outputs(16'h5555, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase 003: Pulse duration of 3 with Master backpressure");
            reset_dut();

            s_axis_tdata = 64'h0003_0000_0000_BEEF;
            s_axis_tvalid = 1;

            wait(s_axis_tready == 1);
            @(posedge aclk);
            s_axis_tvalid = 0;


            wait(m_axis_tvalid == 1);


            @(posedge aclk);
            m_axis_tready = 0;
            repeat(3) @(posedge aclk);


            m_axis_tready = 1;


            wait(m_axis_tvalid == 0);
            @(posedge aclk);

            #1;


            check_outputs(16'hBEEF, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Reset mid-pulse");
            reset_dut();

            s_axis_tdata = 64'h00FF_0000_0000_1234;
            s_axis_tvalid = 1;

            wait(s_axis_tready == 1);
            @(posedge aclk);
            s_axis_tvalid = 0;


            wait(m_axis_tvalid == 1);
            repeat(2) @(posedge aclk);
            aresetn = 0;
            repeat(2) @(posedge aclk);
            aresetn = 1;
            @(posedge aclk);


            #1;



            check_outputs(16'h0000, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Consecutive pulses (Back-to-back)");
            reset_dut();


            s_axis_tdata = 64'h0002_0000_0000_1111;
            s_axis_tvalid = 1;
            wait(s_axis_tready == 1);
            @(posedge aclk);
            s_axis_tvalid = 0;
            wait(m_axis_tvalid == 0);
            @(posedge aclk);


            s_axis_tdata = 64'h0002_0000_0000_2222;
            s_axis_tvalid = 1;
            wait(s_axis_tready == 1);
            @(posedge aclk);
            s_axis_tvalid = 0;
            wait(m_axis_tvalid == 1);
            wait(m_axis_tvalid == 0);
            @(posedge aclk);

            #1;


            check_outputs(16'h2222, 1'b0, 1'b1);
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
        input [15:0] expected_m_axis_tdata;
        input expected_m_axis_tvalid;
        input expected_s_axis_tready;
        begin
            if (expected_m_axis_tdata === (expected_m_axis_tdata ^ m_axis_tdata ^ expected_m_axis_tdata) &&
                expected_m_axis_tvalid === (expected_m_axis_tvalid ^ m_axis_tvalid ^ expected_m_axis_tvalid) &&
                expected_s_axis_tready === (expected_s_axis_tready ^ s_axis_tready ^ expected_s_axis_tready)) begin
                $display("PASS");
                $display("  Outputs: m_axis_tdata=%h, m_axis_tvalid=%b, s_axis_tready=%b",
                         m_axis_tdata, m_axis_tvalid, s_axis_tready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_axis_tdata=%h, m_axis_tvalid=%b, s_axis_tready=%b",
                         expected_m_axis_tdata, expected_m_axis_tvalid, expected_s_axis_tready);
                $display("  Got:      m_axis_tdata=%h, m_axis_tvalid=%b, s_axis_tready=%b",
                         m_axis_tdata, m_axis_tvalid, s_axis_tready);
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
        $dumpvars(0,aclk, aresetn, m_axis_tready, s_axis_tdata, s_axis_tvalid, m_axis_tdata, m_axis_tvalid, s_axis_tready);
    end

endmodule
