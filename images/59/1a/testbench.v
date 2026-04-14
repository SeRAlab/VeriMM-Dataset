`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] addra;
    reg s_axi_aclk;
    reg [31:0] s_axi_wdata;
    reg web;
    wire busy;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addra(addra),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_wdata(s_axi_wdata),
        .web(web),
        .busy(busy),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        s_axi_aclk = 0;
        forever #5 s_axi_aclk = ~s_axi_aclk;
    end

        task reset_dut;

        begin
            web = 0;
            addra = 0;
            s_axi_wdata = 0;
            repeat(2) @(posedge s_axi_aclk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write Operation", test_num);
            reset_dut();

            addra = 12'hA5A;
            s_axi_wdata = 32'hDEADBEEF;
            @(posedge s_axi_aclk);
            web = 1;
            @(posedge s_axi_aclk);
            web = 0;


            wait(done == 1);
            #1;

            check_outputs(0, 1);
            @(posedge s_axi_aclk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write to Address 0 with Data 0", test_num);
            reset_dut();

            addra = 12'h000;
            s_axi_wdata = 32'h00000000;
            @(posedge s_axi_aclk);
            web = 1;
            @(posedge s_axi_aclk);
            web = 0;

            wait(done == 1);
            #1;

            check_outputs(0, 1);
            @(posedge s_axi_aclk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify Idle State", test_num);
            reset_dut();

            addra = 12'hFFF;
            s_axi_wdata = 32'hFFFFFFFF;
            web = 0;
            repeat(5) @(posedge s_axi_aclk);


            #1;



            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequential Back-to-Back Writes", test_num);
            reset_dut();


            addra = 12'h001;
            s_axi_wdata = 32'h11111111;
            @(posedge s_axi_aclk);
            web = 1;
            @(posedge s_axi_aclk);
            web = 0;
            wait(done == 1);


            @(posedge s_axi_aclk);


            addra = 12'h002;
            s_axi_wdata = 32'h22222222;
            @(posedge s_axi_aclk);
            web = 1;
            @(posedge s_axi_aclk);
            web = 0;
            wait(done == 1);

            #1;


            check_outputs(0, 1);
            @(posedge s_axi_aclk);
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
        input expected_busy;
        input expected_done;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, done=%b",
                         busy, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, done=%b",
                         expected_busy, expected_done);
                $display("  Got:      busy=%b, done=%b",
                         busy, done);
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
        $dumpvars(0,addra, s_axi_aclk, s_axi_wdata, web, busy, done);
    end

endmodule
