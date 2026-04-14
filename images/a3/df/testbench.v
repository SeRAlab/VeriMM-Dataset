`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i_irq_x;
    reg i_nmi_x;
    reg rst_x;
    wire [15:0] w_il2mc_addr;
    wire w_il2mc_read;
    wire [7:0] w_il2rf_data;
    wire w_il2rf_pushed;
    wire w_il2rf_set_pch;
    wire w_il2rf_set_pcl;
    wire [7:0] w_mc2il_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_irq_x(i_irq_x),
        .i_nmi_x(i_nmi_x),
        .rst_x(rst_x),
        .w_il2mc_addr(w_il2mc_addr),
        .w_il2mc_read(w_il2mc_read),
        .w_il2rf_data(w_il2rf_data),
        .w_il2rf_pushed(w_il2rf_pushed),
        .w_il2rf_set_pch(w_il2rf_set_pch),
        .w_il2rf_set_pcl(w_il2rf_set_pcl),
        .w_mc2il_data(w_mc2il_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_x = 0;
            i_irq_x = 1;
            i_nmi_x = 1;
            #20;
            rst_x = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Reset/Idle State", test_num);
            reset_dut();


            #1;



            check_outputs(16'h0000, 1'b0, 8'h00, 1'b0, 1'b0, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Trigger NMI", test_num);
            reset_dut();

            @(posedge clk);
            i_nmi_x = 0;
            #1;



            repeat(5) @(posedge clk);



            #1;




            check_outputs(16'hFFFA, 1'b1, 8'h00, 1'b0, 1'b0, 1'b1, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Trigger IRQ", test_num);
            reset_dut();

            @(posedge clk);
            i_irq_x = 0;
            #1;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(16'hFFFE, 1'b1, 8'h00, 1'b0, 1'b0, 1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Latching Persistence", test_num);
            reset_dut();

            @(posedge clk);
            i_irq_x = 0;
            @(posedge clk);
            i_irq_x = 1;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(16'hFFFE, 1'b1, 8'h00, 1'b0, 1'b0, 1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: NMI Priority Check", test_num);
            reset_dut();

            @(posedge clk);
            i_irq_x = 0;
            i_nmi_x = 0;
            #1;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(16'hFFFA, 1'b1, 8'h00, 1'b0, 1'b0, 1'b1, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Register File Set Signals", test_num);
            reset_dut();

            @(posedge clk);
            i_nmi_x = 0;


            repeat(8) @(posedge clk);




            #1;





            check_outputs(16'hFFFA, 1'b1, 8'h00, 1'b0, 1'b0, 1'b1, 8'h00);
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
        input [15:0] expected_w_il2mc_addr;
        input expected_w_il2mc_read;
        input [7:0] expected_w_il2rf_data;
        input expected_w_il2rf_pushed;
        input expected_w_il2rf_set_pch;
        input expected_w_il2rf_set_pcl;
        input [7:0] expected_w_mc2il_data;
        begin
            if (expected_w_il2mc_addr === (expected_w_il2mc_addr ^ w_il2mc_addr ^ expected_w_il2mc_addr) &&
                expected_w_il2mc_read === (expected_w_il2mc_read ^ w_il2mc_read ^ expected_w_il2mc_read) &&
                expected_w_il2rf_data === (expected_w_il2rf_data ^ w_il2rf_data ^ expected_w_il2rf_data) &&
                expected_w_il2rf_pushed === (expected_w_il2rf_pushed ^ w_il2rf_pushed ^ expected_w_il2rf_pushed) &&
                expected_w_il2rf_set_pch === (expected_w_il2rf_set_pch ^ w_il2rf_set_pch ^ expected_w_il2rf_set_pch) &&
                expected_w_il2rf_set_pcl === (expected_w_il2rf_set_pcl ^ w_il2rf_set_pcl ^ expected_w_il2rf_set_pcl) &&
                expected_w_mc2il_data === (expected_w_mc2il_data ^ w_mc2il_data ^ expected_w_mc2il_data)) begin
                $display("PASS");
                $display("  Outputs: w_il2mc_addr=%h, w_il2mc_read=%b, w_il2rf_data=%h, w_il2rf_pushed=%b, w_il2rf_set_pch=%b, w_il2rf_set_pcl=%b, w_mc2il_data=%h",
                         w_il2mc_addr, w_il2mc_read, w_il2rf_data, w_il2rf_pushed, w_il2rf_set_pch, w_il2rf_set_pcl, w_mc2il_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w_il2mc_addr=%h, w_il2mc_read=%b, w_il2rf_data=%h, w_il2rf_pushed=%b, w_il2rf_set_pch=%b, w_il2rf_set_pcl=%b, w_mc2il_data=%h",
                         expected_w_il2mc_addr, expected_w_il2mc_read, expected_w_il2rf_data, expected_w_il2rf_pushed, expected_w_il2rf_set_pch, expected_w_il2rf_set_pcl, expected_w_mc2il_data);
                $display("  Got:      w_il2mc_addr=%h, w_il2mc_read=%b, w_il2rf_data=%h, w_il2rf_pushed=%b, w_il2rf_set_pch=%b, w_il2rf_set_pcl=%b, w_mc2il_data=%h",
                         w_il2mc_addr, w_il2mc_read, w_il2rf_data, w_il2rf_pushed, w_il2rf_set_pch, w_il2rf_set_pcl, w_mc2il_data);
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
        $dumpvars(0,clk, i_irq_x, i_nmi_x, rst_x, w_il2mc_addr, w_il2mc_read, w_il2rf_data, w_il2rf_pushed, w_il2rf_set_pch, w_il2rf_set_pcl, w_mc2il_data);
    end

endmodule
