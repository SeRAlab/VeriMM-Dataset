`timescale 1ns/1ps

module aes_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg [127:0] key_in;
    reg rst_n;
    wire [127:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_round dut (
        .clk(clk),
        .data_in(data_in),
        .key_in(key_in),
        .rst_n(rst_n),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 0;
            key_in = 0;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: All Zeros Data and Key", test_num);

            data_in = 128'h00000000000000000000000000000000;
            key_in  = 128'h00000000000000000000000000000000;

            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h63636363636363636363636363636363);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: FIPS-197 Round 1 Vector", test_num);

            data_in = 128'h193de3bea0f4e22b9ac68d2ae9f84808;
            key_in  = 128'ha0fafe1788542cb123a339392a6c7605;

            @(posedge clk);
            #2;
            #1;

            check_outputs(128'ha4fe7ff2689f352b6b5bef48fc401c17);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: FIPS-197 Round 2 Vector", test_num);

            data_in = 128'ha4fe7ff2689f352b6b5bef48fc401c17;
            key_in  = 128'hc9918732d8478d108d48085429816659;

            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h5a07548b894197e4125b27189a696773);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Structured Pattern with Zero Key", test_num);


            data_in = 128'h000102030405060708090a0b0c0d0e0f;
            key_in  = 128'h00000000000000000000000000000000;

            @(posedge clk);
            #2;





            #1;






            check_outputs(128'heb40ba9ff7cc22a1063e6393169e6b36);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: All Ones Data and Key", test_num);

            data_in = 128'hffffffffffffffffffffffffffffffff;
            key_in  = 128'hffffffffffffffffffffffffffffffff;

            @(posedge clk);
            #2;



            #1;




            check_outputs(128'he9e9e9e9e9e9e9e9e9e9e9e9e9e9e9e9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_round Testbench");
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
        input [127:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, key_in, rst_n, data_out);
    end

endmodule
