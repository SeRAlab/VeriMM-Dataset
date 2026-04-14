`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg sys_clk;
    reg [1:0] test_intlk_status;
    reg [31:0] wb_reg;
    wire err;
    wire err_intlk;
    wire err_wb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sys_clk(sys_clk),
        .test_intlk_status(test_intlk_status),
        .wb_reg(wb_reg),
        .err(err),
        .err_intlk(err_intlk),
        .err_wb(err_wb)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            test_intlk_status = 2'b00;
            wb_reg = 32'h0000_0000;
            @(posedge sys_clk);
            @(posedge sys_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full Match (Zeros)", test_num);
            reset_dut();
            test_intlk_status = 2'b00;
            wb_reg = 32'h0000_0000;


            repeat(3) @(posedge sys_clk);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full Match (Pattern 11)", test_num);
            reset_dut();
            test_intlk_status = 2'b11;
            wb_reg = 32'h0000_0003;

            repeat(3) @(posedge sys_clk);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mismatch - Test Status present, WB missing", test_num);
            reset_dut();
            test_intlk_status = 2'b01;
            wb_reg = 32'h0000_0000;

            repeat(3) @(posedge sys_clk);


            #1;



            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mismatch - WB present, Test Status missing", test_num);
            reset_dut();
            test_intlk_status = 2'b00;
            wb_reg = 32'h0000_0002;

            repeat(3) @(posedge sys_clk);


            #1;



            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Match - ignoring upper WB bits", test_num);
            reset_dut();
            test_intlk_status = 2'b10;
            wb_reg = 32'hAAAA_5502;

            repeat(3) @(posedge sys_clk);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mismatch - Different patterns (11 vs 01)", test_num);
            reset_dut();
            test_intlk_status = 2'b11;
            wb_reg = 32'h0000_0001;

            repeat(3) @(posedge sys_clk);




            #1;





            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronization Delay Verification", test_num);
            reset_dut();


            test_intlk_status = 2'b01;
            wb_reg = 32'h0000_0000;


            @(posedge sys_clk);
            #1;
            if (err == 1'b0) begin
                $display("  Info: Error not yet visible after 1 cycle (as expected)");
            end


            repeat(2) @(posedge sys_clk);
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
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
        input expected_err;
        input expected_err_intlk;
        input expected_err_wb;
        begin
            if (expected_err === (expected_err ^ err ^ expected_err) &&
                expected_err_intlk === (expected_err_intlk ^ err_intlk ^ expected_err_intlk) &&
                expected_err_wb === (expected_err_wb ^ err_wb ^ expected_err_wb)) begin
                $display("PASS");
                $display("  Outputs: err=%b, err_intlk=%b, err_wb=%b",
                         err, err_intlk, err_wb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: err=%b, err_intlk=%b, err_wb=%b",
                         expected_err, expected_err_intlk, expected_err_wb);
                $display("  Got:      err=%b, err_intlk=%b, err_wb=%b",
                         err, err_intlk, err_wb);
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
        $dumpvars(0,sys_clk, test_intlk_status, wb_reg, err, err_intlk, err_wb);
    end

endmodule
