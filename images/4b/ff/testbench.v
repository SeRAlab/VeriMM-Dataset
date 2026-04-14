`timescale 1ns/1ps

module register_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d;
    reg en_n;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_4bit dut (
        .clk(clk),
        .d(d),
        .en_n(en_n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en_n <= 1'b1;
            d <= 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write (en_n=0)", test_num);

            d <= 4'hA;
            en_n <= 1'b0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Disable Write (en_n=1)", test_num);


            d <= 4'h5;
            en_n <= 1'b0;
            @(posedge clk);
            #1;


            d <= 4'hF;
            en_n <= 1'b1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Write boundary values (0x0 and 0xF)", test_num);


            d <= 4'hF;
            en_n <= 1'b0;
            @(posedge clk);
            #1;


            d <= 4'h0;
            en_n <= 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Successive writes", test_num);

            en_n <= 1'b0;
            d <= 4'h1; @(posedge clk); #1;
            d <= 4'h3; @(posedge clk); #1;
            d <= 4'h7; @(posedge clk); #1;
            d <= 4'hB; @(posedge clk); #1;

            #1;


            check_outputs(4'hB);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Enable transition", test_num);


            d <= 4'h2;
            en_n <= 1'b0;
            @(posedge clk); #1;


            en_n <= 1'b1;
            d <= 4'hE;
            @(posedge clk); #1;


            en_n <= 1'b0;
            @(posedge clk); #1;

            #1;


            check_outputs(4'hE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_4bit Testbench");
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, d, en_n, q);
    end

endmodule
