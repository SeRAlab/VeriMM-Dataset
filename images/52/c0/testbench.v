`timescale 1ns/1ps

module ram_32x16_sp_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] addr;
    reg clk;
    reg [15:0] wdata;
    reg we;
    wire [15:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ram_32x16_sp dut (
        .addr(addr),
        .clk(clk),
        .wdata(wdata),
        .we(we),
        .rdata(rdata)
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
            wdata = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            we = 1;
            addr = 5'd15;
            wdata = 16'hA5A5;
            @(posedge clk);
            #1;


            we = 0;
            addr = 5'd15;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address 0", test_num);
            reset_dut();


            we = 1;
            addr = 5'd0;
            wdata = 16'hFFFF;
            @(posedge clk);
            #1;


            we = 0;
            addr = 5'd0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address 31", test_num);
            reset_dut();


            we = 1;
            addr = 5'd31;
            wdata = 16'h1234;
            @(posedge clk);
            #1;


            we = 0;
            addr = 5'd31;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Data", test_num);
            reset_dut();


            we = 1;
            addr = 5'd10;
            wdata = 16'h1111;
            @(posedge clk);
            #1;


            we = 1;
            addr = 5'd10;
            wdata = 16'h2222;
            @(posedge clk);
            #1;


            we = 0;
            addr = 5'd10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h2222);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable check", test_num);
            reset_dut();


            we = 1;
            addr = 5'd20;
            wdata = 16'hBEEF;
            @(posedge clk);
            #1;


            we = 0;
            addr = 5'd20;
            wdata = 16'hDEAD;
            @(posedge clk);
            #1;


            we = 0;
            addr = 5'd20;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hBEEF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ram_32x16_sp Testbench");
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
        input [15:0] expected_rdata;
        begin
            if (expected_rdata === (expected_rdata ^ rdata ^ expected_rdata)) begin
                $display("PASS");
                $display("  Outputs: rdata=%h",
                         rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata=%h",
                         expected_rdata);
                $display("  Got:      rdata=%h",
                         rdata);
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
        $dumpvars(0,addr, clk, wdata, we, rdata);
    end

endmodule
