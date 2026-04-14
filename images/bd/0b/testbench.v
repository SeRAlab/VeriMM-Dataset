`timescale 1ns/1ps

module parallel_load_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg en;
    reg load;
    reg reset;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    parallel_load_register_8bit dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .load(load),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            en = 0;
            load = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Parallel Load (en=1, load=1)", test_num);
            reset_dut();
            en = 1;
            load = 1;
            data_in = 8'hA5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Disabled (en=1, load=0)", test_num);
            reset_dut();

            en = 1;
            load = 1;
            data_in = 8'h55;
            @(posedge clk);
            #1;

            load = 0;
            data_in = 8'hFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Disabled (en=0, load=1)", test_num);
            reset_dut();

            en = 1;
            load = 1;
            data_in = 8'h12;
            @(posedge clk);
            #1;

            en = 0;
            data_in = 8'h34;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Priority", test_num);
            reset_dut();
            en = 1;
            load = 1;
            data_in = 8'hFF;
            reset = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential Loads", test_num);
            reset_dut();
            en = 1;
            load = 1;

            data_in = 8'h11;
            @(posedge clk);
            #1;

            data_in = 8'h22;
            @(posedge clk);
            #1;

            data_in = 8'h33;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Both en and load low", test_num);
            reset_dut();

            en = 1;
            load = 1;
            data_in = 8'hBC;
            @(posedge clk);
            #1;

            en = 0;
            load = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hBC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("parallel_load_register_8bit Testbench");
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, en, load, reset, data_out);
    end

endmodule
