`timescale 1ns/1ps

module sd_card_cmd_handler_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] cmd;
    wire [7:0] resp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_cmd_handler dut (
        .clk(clk),
        .cmd(cmd),
        .resp(resp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            cmd = 2'b0;
            @(posedge clk);
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Running Testcase %0d: Command 0", test_num);
            @(posedge clk);
            cmd <= 2'd0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Running Testcase %0d: Command 1", test_num);
            @(posedge clk);
            cmd <= 2'd1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Running Testcase %0d: Command 2", test_num);
            @(posedge clk);
            cmd <= 2'd2;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Running Testcase %0d: Command 3", test_num);
            @(posedge clk);
            cmd <= 2'd3;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h04);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sd_card_cmd_handler Testbench");
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
        input [7:0] expected_resp;
        begin
            if (expected_resp === (expected_resp ^ resp ^ expected_resp)) begin
                $display("PASS");
                $display("  Outputs: resp=%h",
                         resp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: resp=%h",
                         expected_resp);
                $display("  Got:      resp=%h",
                         resp);
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
        $dumpvars(0,clk, cmd, resp);
    end

endmodule
