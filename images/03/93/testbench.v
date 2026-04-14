`timescale 1ns/1ps

module NVMeCommandRegister_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] cmd_input;
    reg we;
    wire [31:0] cmd_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NVMeCommandRegister dut (
        .clk(clk),
        .cmd_input(cmd_input),
        .we(we),
        .cmd_output(cmd_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            cmd_input = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write", test_num);
            we = 1;
            cmd_input = 32'hA5A5A5A5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Low (Maintain Value)", test_num);


            we = 1;
            cmd_input = 32'h11112222;
            @(posedge clk);
            #1;


            we = 0;
            cmd_input = 32'hFFFFFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h11112222);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Successive Writes", test_num);

            we = 1;
            cmd_input = 32'hCAFEBABE;
            @(posedge clk);
            #1;

            cmd_input = 32'hDEADBEEF;
            @(posedge clk);
            #1;

            cmd_input = 32'h00C0FFEE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00C0FFEE);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Values (Zeros and Ones)", test_num);

            we = 1;
            cmd_input = 32'hFFFFFFFF;
            @(posedge clk);
            #1;

            cmd_input = 32'h00000000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Hold Value Over Idle Cycles", test_num);

            we = 1;
            cmd_input = 32'h12345678;
            @(posedge clk);
            #1;

            we = 0;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NVMeCommandRegister Testbench");
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
        input [31:0] expected_cmd_output;
        begin
            if (expected_cmd_output === (expected_cmd_output ^ cmd_output ^ expected_cmd_output)) begin
                $display("PASS");
                $display("  Outputs: cmd_output=%h",
                         cmd_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cmd_output=%h",
                         expected_cmd_output);
                $display("  Got:      cmd_output=%h",
                         cmd_output);
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
        $dumpvars(0,clk, cmd_input, we, cmd_output);
    end

endmodule
