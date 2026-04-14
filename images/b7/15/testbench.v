`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] m_addr;
    reg m_branch;
    reg m_memrd;
    reg m_memwr;
    reg [11:0] m_pc_in;
    reg [63:0] m_write_data;
    reg m_zero;
    wire [11:0] m_pc_out;
    wire m_pcsrc;
    wire [63:0] m_read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .m_addr(m_addr),
        .m_branch(m_branch),
        .m_memrd(m_memrd),
        .m_memwr(m_memwr),
        .m_pc_in(m_pc_in),
        .m_write_data(m_write_data),
        .m_zero(m_zero),
        .m_pc_out(m_pc_out),
        .m_pcsrc(m_pcsrc),
        .m_read_data(m_read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            m_addr = 64'd0;
            m_branch = 1'b0;
            m_memrd = 1'b0;
            m_memwr = 1'b0;
            m_pc_in = 12'd0;
            m_write_data = 64'd0;
            m_zero = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Branch Logic and PC Pass-through", test_num);

            m_branch = 1'b1;
            m_zero = 1'b1;
            m_pc_in = 12'hABC;

            #10;


            #1;



            check_outputs(12'hABC, 1'b1, 64'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Branch Logic (Not Taken)", test_num);

            m_branch = 1'b1;
            m_zero = 1'b0;
            m_pc_in = 12'h123;

            #10;


            #1;



            check_outputs(12'h123, 1'b0, 64'h0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Memory Write and Read", test_num);


            m_addr = 64'h0000_0000_0000_0010;
            m_write_data = 64'hDEAD_BEEF_CAFE_BABE;
            m_memwr = 1'b1;


            @(negedge clk);
            #2 m_memwr = 1'b0;


            @(posedge clk);
            m_memrd = 1'b1;
            m_addr = 64'h0000_0000_0000_0010;

            #10;


            #1;



            check_outputs(12'h000, 1'b0, 64'hDEAD_BEEF_CAFE_BABE);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Write clears Read Data Register", test_num);


            m_addr = 64'hA0;
            m_write_data = 64'h1111_2222_3333_4444;
            m_memwr = 1'b1;
            @(negedge clk);
            #2 m_memwr = 1'b0;


            @(posedge clk);
            m_memrd = 1'b1;
            #10;



            m_memrd = 1'b0;
            m_addr = 64'hB0;
            m_write_data = 64'h5555_6666_7777_8888;
            m_memwr = 1'b1;

            @(negedge clk);
            #2 m_memwr = 1'b0;

            #10;


            #1;



            check_outputs(12'h000, 1'b0, 64'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Read Uninitialized Address", test_num);

            m_addr = 64'hFFFF_FFFF_FFFF_F000;
            m_memrd = 1'b1;
            m_pc_in = 12'hFFF;

            #10;


            #1;



            check_outputs(12'hFFF, 1'b0, 64'h0);
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
        input [11:0] expected_m_pc_out;
        input expected_m_pcsrc;
        input [63:0] expected_m_read_data;
        begin
            if (expected_m_pc_out === (expected_m_pc_out ^ m_pc_out ^ expected_m_pc_out) &&
                expected_m_pcsrc === (expected_m_pcsrc ^ m_pcsrc ^ expected_m_pcsrc) &&
                expected_m_read_data === (expected_m_read_data ^ m_read_data ^ expected_m_read_data)) begin
                $display("PASS");
                $display("  Outputs: m_pc_out=%h, m_pcsrc=%b, m_read_data=%h",
                         m_pc_out, m_pcsrc, m_read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_pc_out=%h, m_pcsrc=%b, m_read_data=%h",
                         expected_m_pc_out, expected_m_pcsrc, expected_m_read_data);
                $display("  Got:      m_pc_out=%h, m_pcsrc=%b, m_read_data=%h",
                         m_pc_out, m_pcsrc, m_read_data);
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
        $dumpvars(0,clk, m_addr, m_branch, m_memrd, m_memwr, m_pc_in, m_write_data, m_zero, m_pc_out, m_pcsrc, m_read_data);
    end

endmodule
