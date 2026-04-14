`timescale 1ns/1ps

module simplified_sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg reset;
    reg start;
    wire [255:0] hash_output;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simplified_sha256 dut (
        .clk(clk),
        .message(message),
        .reset(reset),
        .start(start),
        .hash_output(hash_output),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            message = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            $display("DUT Reset Complete.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase %03d: All Zeros", test_num);
            reset_dut();
            message = 512'h0;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(valid);
            @(posedge clk);



            #1;




            check_outputs(256'hda5698be17b9b46962335799779f4f835e79038d8fb28196c3a1e3d39967d958, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase %03d: Alternating Bits", test_num);
            reset_dut();
            message = 512'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(valid);
            @(posedge clk);

            #1;


            check_outputs(256'h53457106886e927f804246944a9559c5d1e43187a08f516858e3f94c96561f52, 1'b1);
        end
        endtask

    task testcase003;

        reg [511:0] inc_msg;
        integer i;
        begin
            test_num = 3;
            $display("\nRunning Testcase %03d: Incremental Bytes", test_num);
            reset_dut();
            for(i=0; i<64; i=i+1) begin
                inc_msg[i*8 +: 8] = i[7:0];
            end
            message = inc_msg;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(valid);
            @(posedge clk);

            #1;


            check_outputs(256'hf377755b38f830495393a547285514f38769359a35e729352e82103328e28352, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase %03d: All Ones", test_num);
            reset_dut();
            message = {512{1'b1}};
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(valid);
            @(posedge clk);

            #1;


            check_outputs(256'h2380a049f76a591e605658e0a301476d080f4f95b0042457630737146522f252, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simplified_sha256 Testbench");
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
        input [255:0] expected_hash_output;
        input expected_valid;
        begin
            if (expected_hash_output === (expected_hash_output ^ hash_output ^ expected_hash_output) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: hash_output=%h, valid=%b",
                         hash_output, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_output=%h, valid=%b",
                         expected_hash_output, expected_valid);
                $display("  Got:      hash_output=%h, valid=%b",
                         hash_output, valid);
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
        $dumpvars(0,clk, message, reset, start, hash_output, valid);
    end

endmodule
