`timescale 1ns/1ps

module sync_ram_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [7:0] din;
    reg we;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_ram dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .we(we),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            addr = 0;
            din = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Basic Write/Read at Addr 0", test_num);


            @(negedge clk);
            we = 1; addr = 4'h0; din = 8'hA5;
            @(negedge clk);


            we = 0; addr = 4'h0;
            @(negedge clk);

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Boundary Address Write/Read (Addr 15)", test_num);

            @(negedge clk);
            we = 1; addr = 4'hF; din = 8'h5A;
            @(negedge clk);

            we = 0; addr = 4'hF;
            @(negedge clk);

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Sequential Writes and Reads", test_num);


            @(negedge clk);
            we = 1; addr = 4'h2; din = 8'h22;
            @(negedge clk);
            we = 1; addr = 4'h3; din = 8'h33;
            @(negedge clk);


            we = 0; addr = 4'h2;
            @(negedge clk);

            #1;


            check_outputs(8'h22);


            we = 0; addr = 4'h3;
            @(negedge clk);

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Overwriting memory", test_num);


            @(negedge clk);
            we = 1; addr = 4'h7; din = 8'h11;
            @(negedge clk);


            we = 1; addr = 4'h7; din = 8'h99;
            @(negedge clk);


            we = 0; addr = 4'h7;
            @(negedge clk);

            #1;


            check_outputs(8'h99);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Write Enable verification", test_num);


            @(negedge clk);
            we = 1; addr = 4'hA; din = 8'hCC;
            @(negedge clk);


            we = 0; addr = 4'hA; din = 8'hDD;
            @(negedge clk);


            addr = 4'hA;
            @(negedge clk);

            #1;


            check_outputs(8'hCC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_ram Testbench");
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
        input [7:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,addr, clk, din, we, dout);
    end

endmodule
