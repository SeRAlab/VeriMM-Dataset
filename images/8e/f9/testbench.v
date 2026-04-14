`timescale 1ns/1ps

module register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_8bit dut (
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
            load = 0;
            data_in = 8'h00;
            @(negedge clk);


            load = 1;
            data_in = 8'h00;
            @(negedge clk);
            load = 0;
            data_in = 8'h00;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Load");
            reset_dut();
            test_num = 1;
            data_in = 8'hA5;
            load = 1;
            @(negedge clk);
            load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Hold Value");
            reset_dut();
            test_num = 2;

            data_in = 8'h5A;
            load = 1;
            @(negedge clk);

            data_in = 8'hFF;
            load = 0;
            @(negedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Load All Ones");
            reset_dut();
            test_num = 3;
            data_in = 8'hFF;
            load = 1;
            @(negedge clk);
            load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Successive Loads");
            reset_dut();
            test_num = 4;

            data_in = 8'h12;
            load = 1;
            @(negedge clk);

            data_in = 8'h34;
            load = 1;
            @(negedge clk);
            load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h34);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Ignore Data Change");
            reset_dut();
            test_num = 5;

            data_in = 8'hCC;
            load = 1;
            @(negedge clk);
            load = 0;

            data_in = 8'h11; @(negedge clk);
            data_in = 8'h22; @(negedge clk);
            data_in = 8'h33; @(negedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(8'hCC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_8bit Testbench");
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
        $dumpvars(0,clk, data_in, load, q);
    end

endmodule
