`timescale 1ns/1ps

module aes_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [127:0] key;
    reg [127:0] plaintext;
    wire [127:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_encrypt dut (
        .clk(clk),
        .enable(enable),
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            key = 0;
            plaintext = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: All Zeros Input", test_num);

            plaintext = 128'h00000000000000000000000000000000;
            key       = 128'h00000000000000000000000000000000;
            enable = 1;

            @(posedge clk);
            #2;
            enable = 0;




            #1;





            check_outputs(128'h63636363636363636363636363636363);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Standard AES Round Vector", test_num);



            plaintext = 128'h193de3bea0f4e22b9ac68d2ae9e8ec08;
            key       = 128'hf2c295f27a96b9435935807a73599123;
            enable = 1;

            @(posedge clk);
            #2;
            enable = 0;


            #1;



            check_outputs(128'h4773b91ff72f3543d1c6703c55ad9100);
        end
        endtask

    task testcase003;

        reg [127:0] last_output;
        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Enable Signal Logic Check", test_num);


            plaintext = 128'hffffffffffffffffffffffffffffffff;
            key       = 128'h00000000000000000000000000000000;
            enable = 1;
            @(posedge clk);
            #2;
            last_output = ciphertext;
            enable = 0;


            plaintext = 128'h123456789ABCDEF0123456789ABCDEF0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(last_output);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Alternative Vector Check", test_num);

            plaintext = 128'h00102030405060708090a0b0c0d0e0f0;
            key       = 128'hd6aa74fdd2af72fadaa678f1d6ab76fe;
            enable = 1;

            @(posedge clk);
            #2;
            enable = 0;

            #1;


            check_outputs(128'h89d810e884021c19dc79305041183f13);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_encrypt Testbench");
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
        input [127:0] expected_ciphertext;
        begin
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h",
                         ciphertext);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h",
                         expected_ciphertext);
                $display("  Got:      ciphertext=%h",
                         ciphertext);
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
        $dumpvars(0,clk, enable, key, plaintext, ciphertext);
    end

endmodule
