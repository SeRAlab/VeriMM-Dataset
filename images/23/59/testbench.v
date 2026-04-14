`timescale 1ns/1ps

module NVMeController_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cmd_complete;
    reg load_cmd;
    reg [3:0] new_cmd;
    wire cmd_done;
    wire [3:0] cmd_reg;
    wire [3:0] status_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NVMeController dut (
        .clk(clk),
        .cmd_complete(cmd_complete),
        .load_cmd(load_cmd),
        .new_cmd(new_cmd),
        .cmd_done(cmd_done),
        .cmd_reg(cmd_reg),
        .status_reg(status_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load_cmd = 0;
            cmd_complete = 0;
            new_cmd = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Loading Command 0xA", test_num);
            reset_dut();

            new_cmd = 4'hA;
            load_cmd = 1;
            @(posedge clk);
            #1;
            load_cmd = 0;


            #1;



            check_outputs(1'b0, 4'hA, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Loading Command 0x5 and Completing", test_num);
            reset_dut();


            new_cmd = 4'h5;
            load_cmd = 1;
            @(posedge clk);
            #1;
            load_cmd = 0;


            cmd_complete = 1;
            @(posedge clk);
            #1;
            cmd_complete = 0;


            #1;



            check_outputs(1'b1, 4'h5, 4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Verify load_cmd = 0 inhibits loading", test_num);
            reset_dut();

            new_cmd = 4'hF;
            load_cmd = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 4'h0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Back-to-back Command Sequence", test_num);
            reset_dut();


            new_cmd = 4'h3;
            load_cmd = 1;
            @(posedge clk);
            #1;
            load_cmd = 0;
            cmd_complete = 1;
            @(posedge clk);
            #1;
            cmd_complete = 0;


            new_cmd = 4'h7;
            load_cmd = 1;
            @(posedge clk);
            #1;
            load_cmd = 0;




            #1;





            check_outputs(1'b0, 4'h7, 4'h3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NVMeController Testbench");
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
        input expected_cmd_done;
        input [3:0] expected_cmd_reg;
        input [3:0] expected_status_reg;
        begin
            if (expected_cmd_done === (expected_cmd_done ^ cmd_done ^ expected_cmd_done) &&
                expected_cmd_reg === (expected_cmd_reg ^ cmd_reg ^ expected_cmd_reg) &&
                expected_status_reg === (expected_status_reg ^ status_reg ^ expected_status_reg)) begin
                $display("PASS");
                $display("  Outputs: cmd_done=%b, cmd_reg=%h, status_reg=%h",
                         cmd_done, cmd_reg, status_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cmd_done=%b, cmd_reg=%h, status_reg=%h",
                         expected_cmd_done, expected_cmd_reg, expected_status_reg);
                $display("  Got:      cmd_done=%b, cmd_reg=%h, status_reg=%h",
                         cmd_done, cmd_reg, status_reg);
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
        $dumpvars(0,clk, cmd_complete, load_cmd, new_cmd, cmd_done, cmd_reg, status_reg);
    end

endmodule
