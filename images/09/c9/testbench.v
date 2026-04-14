`timescale 1ns/1ps

module SHA256_Hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [255:0] message;
    reg message_valid;
    reg reset;
    wire [255:0] hash;
    wire hash_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SHA256_Hash dut (
        .clk(clk),
        .enable(enable),
        .message(message),
        .message_valid(message_valid),
        .reset(reset),
        .hash(hash),
        .hash_valid(hash_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            enable = 0;
            message = 0;
            message_valid = 0;
            repeat (5) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Input", test_num);
            reset_dut();

            enable = 1;
            message = 256'h0;
            message_valid = 1;
            @(posedge clk);
            message_valid = 0;


            wait(hash_valid === 1);



            #1;




            check_outputs(256'h4700d060775590677901094a1a121570d61741951f734790e769496030c49833, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Input", test_num);
            reset_dut();

            enable = 1;
            message = {256{1'b1}};
            message_valid = 1;
            @(posedge clk);
            message_valid = 0;

            wait(hash_valid === 1);


            #1;



            check_outputs(256'hef71663b98755609347895f32a5146d65451e0406d44ef87994e45e7f7819077, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Pattern", test_num);
            reset_dut();

            enable = 1;
            message = {128{2'b01}};
            message_valid = 1;
            @(posedge clk);
            message_valid = 0;

            wait(hash_valid === 1);

            #1;


            check_outputs(256'h953a60a7e0896081033230a430985f54f9d0c9f13d80d238258e70e9a59335df, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable Stalling Test", test_num);
            reset_dut();

            enable = 1;
            message = 256'hDEADBEEFCAFEBABE123456788765432100112233445566778899AABBCCDDEEFF;
            message_valid = 1;
            @(posedge clk);
            message_valid = 0;


            repeat(5) @(posedge clk);
            enable = 0;
            repeat(10) @(posedge clk);


            if (hash_valid === 1) begin
                $display("FAIL: hash_valid asserted while enable was low");
            end

            enable = 1;
            wait(hash_valid === 1);

            #1;


            check_outputs(256'h534449856f6f1c4df9e614f24458316dfa99478f654b42319208759d5718df28, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Mid-Operation", test_num);
            reset_dut();

            enable = 1;
            message = 256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            message_valid = 1;
            @(posedge clk);
            message_valid = 0;


            repeat(10) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;


            message_valid = 1;
            @(posedge clk);
            message_valid = 0;

            wait(hash_valid === 1);

            #1;


            check_outputs(256'h63e26217462227f12e2f3d1323ca7941215c2d30807085750d0617387cc83ec4, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SHA256_Hash Testbench");
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
        input [255:0] expected_hash;
        input expected_hash_valid;
        begin
            if (expected_hash === (expected_hash ^ hash ^ expected_hash) &&
                expected_hash_valid === (expected_hash_valid ^ hash_valid ^ expected_hash_valid)) begin
                $display("PASS");
                $display("  Outputs: hash=%h, hash_valid=%b",
                         hash, hash_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h, hash_valid=%b",
                         expected_hash, expected_hash_valid);
                $display("  Got:      hash=%h, hash_valid=%b",
                         hash, hash_valid);
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
        $dumpvars(0,clk, enable, message, message_valid, reset, hash, hash_valid);
    end

endmodule
