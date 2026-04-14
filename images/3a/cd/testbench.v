`timescale 1ns/1ps

module md5_simple_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data;
    reg start;
    wire done;
    wire [31:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_simple_hash dut (
        .clk(clk),
        .data(data),
        .start(start),
        .done(done),
        .hash(hash)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task run_hash_test;

        input [127:0] input_data;
        input [31:0] expected_hash;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = %h", test_num, input_data);


            data = input_data;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            fork : wait_or_timeout
                begin
                    wait(done == 1);
                    disable wait_or_timeout;
                end
                begin
                    repeat(100) @(posedge clk);
                    $display("Timeout waiting for done!");
                    disable wait_or_timeout;
                end
            join


            #1;



            check_outputs(1'b1, expected_hash);


            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            reset_dut();

            run_hash_test(128'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            run_hash_test({4{32'hFFFFFFFF}}, 32'h0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();


            run_hash_test({32'h1, 32'h2, 32'h3, 32'h4}, 32'hA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();



            run_hash_test({32'hAAAAAAAA, 32'h55555555, 32'hAAAAAAAA, 32'h55555555}, 32'hFFFFFFFE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();




            run_hash_test(128'h1234567887654321DEADBEEFCAFEBABE, 32'hA9A419AA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_simple_hash Testbench");
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
        input expected_done;
        input [31:0] expected_hash;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hash === (expected_hash ^ hash ^ expected_hash)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hash=%h",
                         done, hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hash=%h",
                         expected_done, expected_hash);
                $display("  Got:      done=%b, hash=%h",
                         done, hash);
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
        $dumpvars(0,clk, data, start, done, hash);
    end

endmodule
