`timescale 1ns/1ps

module eth_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg retrieve;
    reg rst;
    reg store;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eth_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .retrieve(retrieve),
        .rst(rst),
        .store(store),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            store = 0;
            retrieve = 0;
            data_in = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic store and retrieve", test_num);
            reset_dut();


            data_in = 8'hA5;
            store = 1;
            @(posedge clk);
            #1 store = 0;


            retrieve = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
            retrieve = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overwriting existing data", test_num);
            reset_dut();


            data_in = 8'h11;
            store = 1;
            @(posedge clk);
            #1;


            data_in = 8'h22;
            store = 1;
            @(posedge clk);
            #1 store = 0;


            retrieve = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22);
            retrieve = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify store signal gated", test_num);
            reset_dut();


            data_in = 8'hCC;
            store = 1;
            @(posedge clk);
            #1;


            data_in = 8'hDD;
            store = 0;
            @(posedge clk);
            #1;


            retrieve = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hCC);
            retrieve = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset clears stored data", test_num);
            reset_dut();


            data_in = 8'hFF;
            store = 1;
            @(posedge clk);
            #1 store = 0;


            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);


            retrieve = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
            retrieve = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Store and retrieve zero value", test_num);
            reset_dut();


            data_in = 8'h00;
            store = 1;
            @(posedge clk);
            #1 store = 0;


            retrieve = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
            retrieve = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eth_mac_controller Testbench");
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
        $dumpvars(0,clk, data_in, retrieve, rst, store, data_out);
    end

endmodule
