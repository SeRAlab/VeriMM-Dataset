`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] gen_wr_b_gen_word_wide_mem_reg;
    reg [3:0] mac_addr_ram_addr;
    reg mac_addr_ram_we;
    reg s_axi_aclk;
    wire [3:0] Q;
    wire [1:0] rdDestAddrNib_D_t_q_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .gen_wr_b_gen_word_wide_mem_reg(gen_wr_b_gen_word_wide_mem_reg),
        .mac_addr_ram_addr(mac_addr_ram_addr),
        .mac_addr_ram_we(mac_addr_ram_we),
        .s_axi_aclk(s_axi_aclk),
        .Q(Q),
        .rdDestAddrNib_D_t_q_reg(rdDestAddrNib_D_t_q_reg)
    );

    // Clock generation (10ns period)
    initial begin
        s_axi_aclk = 0;
        forever #5 s_axi_aclk = ~s_axi_aclk;
    end

        task reset_dut;

        begin
            mac_addr_ram_we = 0;
            mac_addr_ram_addr = 4'b0000;
            gen_wr_b_gen_word_wide_mem_reg = 4'b0000;
            @(posedge s_axi_aclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %0d: Write/Read Address 0", test_num);
            reset_dut();


            mac_addr_ram_we = 1;
            mac_addr_ram_addr = 4'h0;
            gen_wr_b_gen_word_wide_mem_reg = 4'hA;
            @(posedge s_axi_aclk);
            #1;


            mac_addr_ram_we = 0;
            #1;

            check_outputs(4'hA, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %0d: Write/Read Address 15", test_num);
            reset_dut();


            mac_addr_ram_we = 1;
            mac_addr_ram_addr = 4'hF;
            gen_wr_b_gen_word_wide_mem_reg = 4'h5;
            @(posedge s_axi_aclk);
            #1;


            mac_addr_ram_we = 0;
            #1;

            check_outputs(4'h5, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %0d: Verify Write Enable", test_num);
            reset_dut();


            mac_addr_ram_we = 1;
            mac_addr_ram_addr = 4'h5;
            gen_wr_b_gen_word_wide_mem_reg = 4'h7;
            @(posedge s_axi_aclk);
            #1;


            mac_addr_ram_we = 0;
            gen_wr_b_gen_word_wide_mem_reg = 4'hE;
            @(posedge s_axi_aclk);
            #1;


            #1;



            check_outputs(4'h7, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %0d: Verify address LSB bits", test_num);
            reset_dut();


            mac_addr_ram_we = 1;
            mac_addr_ram_addr = 4'b1010;
            gen_wr_b_gen_word_wide_mem_reg = 4'h1;
            @(posedge s_axi_aclk);
            #1;


            #1;



            check_outputs(4'h1, 2'b10);


            mac_addr_ram_we = 0;
            mac_addr_ram_addr = 4'b0110;
            @(posedge s_axi_aclk);
            #1;




            #1;





            check_outputs(Q, 2'b10);
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
        input [3:0] expected_Q;
        input [1:0] expected_rdDestAddrNib_D_t_q_reg;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_rdDestAddrNib_D_t_q_reg === (expected_rdDestAddrNib_D_t_q_reg ^ rdDestAddrNib_D_t_q_reg ^ expected_rdDestAddrNib_D_t_q_reg)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, rdDestAddrNib_D_t_q_reg=%h",
                         Q, rdDestAddrNib_D_t_q_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, rdDestAddrNib_D_t_q_reg=%h",
                         expected_Q, expected_rdDestAddrNib_D_t_q_reg);
                $display("  Got:      Q=%h, rdDestAddrNib_D_t_q_reg=%h",
                         Q, rdDestAddrNib_D_t_q_reg);
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
        $dumpvars(0,gen_wr_b_gen_word_wide_mem_reg, mac_addr_ram_addr, mac_addr_ram_we, s_axi_aclk, Q, rdDestAddrNib_D_t_q_reg);
    end

endmodule
