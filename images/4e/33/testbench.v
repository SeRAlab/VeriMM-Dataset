`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [10:0] Data_In;
    reg [3:0] Mutex_Addr_I_reg;
    reg [8:0] Mutex_Wr_Data_I_reg;
    reg [1:0] Q;
    reg S0_AXI_ACLK;
    reg Write_Strobe;
    wire [8:0] D;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data_In(Data_In),
        .Mutex_Addr_I_reg(Mutex_Addr_I_reg),
        .Mutex_Wr_Data_I_reg(Mutex_Wr_Data_I_reg),
        .Q(Q),
        .S0_AXI_ACLK(S0_AXI_ACLK),
        .Write_Strobe(Write_Strobe),
        .D(D)
    );

    // Clock generation (10ns period)
    initial begin
        S0_AXI_ACLK = 0;
        forever #5 S0_AXI_ACLK = ~S0_AXI_ACLK;
    end

        task reset_dut;

        begin
            Data_In = 11'd0;
            Mutex_Addr_I_reg = 4'd0;
            Mutex_Wr_Data_I_reg = 9'd0;
            Write_Strobe = 1'b0;
            Q = 2'b00;
            repeat(2) @(posedge S0_AXI_ACLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Write 11'h7FF to Channel 0", test_num);
            Data_In = 11'h7FF;
            Mutex_Addr_I_reg = 4'b0001;
            Write_Strobe = 1'b1;
            @(posedge S0_AXI_ACLK);
            #1;
            Write_Strobe = 1'b0;
            Q = 2'b00;
            @(posedge S0_AXI_ACLK);
            #1;
            #1;

            check_outputs(9'h1FF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Write 11'h123 to Channel 1", test_num);
            Data_In = 11'h123;
            Mutex_Addr_I_reg = 4'b0010;
            Write_Strobe = 1'b1;
            @(posedge S0_AXI_ACLK);
            #1;
            Write_Strobe = 1'b0;
            Q = 2'b01;
            @(posedge S0_AXI_ACLK);
            #1;
            #1;

            check_outputs(9'h123);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Write 11'h456 to Channel 2", test_num);
            Data_In = 11'h456;
            Mutex_Addr_I_reg = 4'b0100;
            Write_Strobe = 1'b1;
            @(posedge S0_AXI_ACLK);
            #1;
            Write_Strobe = 1'b0;
            Q = 2'b10;
            @(posedge S0_AXI_ACLK);
            #1;
            #1;

            check_outputs(9'h056);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Write 11'h0AA to Channel 3", test_num);
            Data_In = 11'h0AA;
            Mutex_Addr_I_reg = 4'b1000;
            Write_Strobe = 1'b1;
            @(posedge S0_AXI_ACLK);
            #1;
            Write_Strobe = 1'b0;
            Q = 2'b11;
            @(posedge S0_AXI_ACLK);
            #1;
            #1;

            check_outputs(9'h0AA);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Attempt write with Strobe LOW", test_num);
            Data_In = 11'h1FF;
            Mutex_Addr_I_reg = 4'b0001;
            Write_Strobe = 1'b0;
            @(posedge S0_AXI_ACLK);
            #1;
            Q = 2'b00;
            @(posedge S0_AXI_ACLK);
            #1;
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Persistent Multi-channel check", test_num);


            Data_In = 11'h001; Mutex_Addr_I_reg = 4'b0001; Write_Strobe = 1'b1;
            @(posedge S0_AXI_ACLK); #1;

            Data_In = 11'h003; Mutex_Addr_I_reg = 4'b1000;
            @(posedge S0_AXI_ACLK); #1;

            Write_Strobe = 1'b0;
            Q = 2'b00;
            @(posedge S0_AXI_ACLK); #1;
            if (D !== 9'h001) $display("Error in Ch0 persistence");

            Q = 2'b11;
            @(posedge S0_AXI_ACLK); #1;
            #1;

            check_outputs(9'h003);
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
        input [8:0] expected_D;
        begin
            if (expected_D === (expected_D ^ D ^ expected_D)) begin
                $display("PASS");
                $display("  Outputs: D=%h",
                         D);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h",
                         expected_D);
                $display("  Got:      D=%h",
                         D);
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
        $dumpvars(0,Data_In, Mutex_Addr_I_reg, Mutex_Wr_Data_I_reg, Q, S0_AXI_ACLK, Write_Strobe, D);
    end

endmodule
