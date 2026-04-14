`timescale 1ns/1ps

module parallel_register_tb;

    // Testbench signals (sequential circuit)
    reg clear_n;
    reg clk;
    reg [63:0] data_in;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    parallel_register dut (
        .clear_n(clear_n),
        .clk(clk),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clear_n = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            clear_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load All Ones", test_num);
            reset_dut();
            data_in = 64'hFFFFFFFFFFFFFFFF;
            clear_n = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load All Zeros", test_num);
            reset_dut();
            data_in = 64'h0000000000000000;
            clear_n = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Pattern 555...", test_num);
            reset_dut();
            data_in = 64'h5555555555555555;
            clear_n = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h5555555555555555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Pattern AAA...", test_num);
            reset_dut();
            data_in = 64'hAAAAAAAAAAAAAAAA;
            clear_n = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Clear Priority Check", test_num);
            reset_dut();

            data_in = 64'hDEADBEEFCAFEBABE;
            clear_n = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Output Stability (Hold)", test_num);
            reset_dut();

            data_in = 64'h1234567887654321;
            clear_n = 1;
            @(posedge clk);
            #1;

            data_in = 64'hFFFFFFFFFFFFFFFF;
            #5;

            #1;


            check_outputs(64'h1234567887654321);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Consecutive Updates", test_num);
            reset_dut();

            data_in = 64'h1; @(posedge clk);
            data_in = 64'h2; @(posedge clk);
            data_in = 64'h3; @(posedge clk);
            #1;
            #1;

            check_outputs(64'h3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("parallel_register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [63:0] expected_data_out;
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
        $dumpvars(0,clear_n, clk, data_in, data_out);
    end

endmodule
