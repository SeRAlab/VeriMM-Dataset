`timescale 1ns/1ps

module register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load <= 1'b1;
            data_in <= 16'h0000;
            @(posedge clk);
            load <= 1'b0;
            data_in <= 16'h0000;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Load basic value 16'hA5A5", test_num);

            @(posedge clk);
            load <= 1'b1;
            data_in <= 16'hA5A5;

            @(posedge clk);
            load <= 1'b0;
            data_in <= 16'hFFFF;

            #1;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Verify retention (load=0)", test_num);


            @(posedge clk);
            load <= 1'b1;
            data_in <= 16'h1234;


            @(posedge clk);
            load <= 1'b0;
            data_in <= 16'h5678;


            @(posedge clk);

            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Load 0xFFFF", test_num);

            @(posedge clk);
            load <= 1'b1;
            data_in <= 16'hFFFF;

            @(posedge clk);
            load <= 1'b0;

            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential loads", test_num);

            @(posedge clk);
            load <= 1'b1;
            data_in <= 16'hAAAA;

            @(posedge clk);
            data_in <= 16'h5555;

            @(posedge clk);
            load <= 1'b0;

            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Verify synchronous behavior", test_num);

            #2;
            load <= 1'b1;
            data_in <= 16'hEEEE;


            #1;
            if (q === 16'hEEEE) begin
                $display("FAIL: Asynchronous load detected!");
            end

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hEEEE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register Testbench");
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
        input [15:0] expected_q;
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
        $dumpvars(0,clk, data_in, load, q);
    end

endmodule
