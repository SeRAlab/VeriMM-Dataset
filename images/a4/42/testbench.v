`timescale 1ns/1ps

module reg_with_clear_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [7:0] data;
    reg en;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_with_clear dut (
        .clk(clk),
        .clr(clr),
        .data(data),
        .en(en),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            en = 0;
            data = 8'h00;
            #15;
            clr = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial Reset Verification", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Load with Enable", test_num);
            reset_dut();
            @(posedge clk);
            en <= 1;
            data <= 8'hA5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable Inhibition Test", test_num);
            reset_dut();

            @(posedge clk);
            en <= 1;
            data <= 8'h55;
            @(posedge clk);

            en <= 0;
            data <= 8'hFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Asynchronous Clear Priority", test_num);
            reset_dut();
            @(posedge clk);
            en <= 1;
            data <= 8'hFF;
            @(posedge clk);
            #2;

            clr = 1;
            #1;
            #1;

            check_outputs(8'h00);
            clr = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-cycle Data Transitions", test_num);
            reset_dut();
            en <= 1;
            @(posedge clk);
            data <= 8'h11;
            @(posedge clk);
            data <= 8'h22;
            @(posedge clk);
            data <= 8'h33;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Stability Between Clock Edges", test_num);
            reset_dut();
            @(posedge clk);
            en <= 1;
            data <= 8'hAA;
            @(posedge clk);
            #1;

            data <= 8'hBB;
            #2;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_with_clear Testbench");
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, clr, data, en, q);
    end

endmodule
