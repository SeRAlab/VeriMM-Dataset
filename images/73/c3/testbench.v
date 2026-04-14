`timescale 1ns/1ps

module reg32_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] d;
    reg load;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg32 dut (
        .clk(clk),
        .d(d),
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
            load <= 0;
            d <= 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Basic Load Operation", test_num);
            reset_dut();

            d <= 32'hDEADBEEF;
            load <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Load Disabled (Hold Value)", test_num);
            reset_dut();


            d <= 32'h12345678;
            load <= 1;
            @(posedge clk);
            #1;


            d <= 32'hFFFFFFFF;
            load <= 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Boundary Values (0x0 and 0xFFFFFFFF)", test_num);
            reset_dut();

            d <= 32'h00000000;
            load <= 1;
            @(posedge clk);
            #1;

            d <= 32'hFFFFFFFF;
            load <= 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Alternating Bits", test_num);
            reset_dut();

            d <= 32'hAAAAAAAA;
            load <= 1;
            @(posedge clk);
            #1;

            d <= 32'h55555555;
            load <= 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h55555555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Data Changes Without Load", test_num);
            reset_dut();


            d <= 32'hCAFEFACE;
            load <= 1;
            @(posedge clk);
            #1;

            load <= 0;
            d <= 32'h00001111;
            @(posedge clk);
            #1;
            d <= 32'h22223333;
            @(posedge clk);
            #1;
            d <= 32'h44445555;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hCAFEFACE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Back-to-back Load Operations", test_num);
            reset_dut();

            load <= 1;
            d <= 32'h1;
            @(posedge clk);
            #1;
            d <= 32'h2;
            @(posedge clk);
            #1;
            d <= 32'h3;
            @(posedge clk);
            #1;
            d <= 32'h4;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg32 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [31:0] expected_q;
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
        $dumpvars(0,clk, d, load, q);
    end

endmodule
