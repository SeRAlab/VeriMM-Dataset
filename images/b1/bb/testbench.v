`timescale 1ns/1ps

module ram_256x16_dp_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] raddr;
    reg [7:0] waddr;
    reg [15:0] wdata;
    reg we;
    wire [15:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ram_256x16_dp dut (
        .clk(clk),
        .raddr(raddr),
        .waddr(waddr),
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
            waddr = 0;
            wdata = 0;
            raddr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            waddr = 8'hA5;
            wdata = 16'h1234;
            we = 1;

            @(posedge clk);
            #1 we = 0;


            raddr = 8'hA5;
            #2;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Address Check", test_num);
            reset_dut();


            waddr = 8'h00; wdata = 16'hAAAA; we = 1;
            @(posedge clk);


            waddr = 8'hFF; wdata = 16'h5555; we = 1;
            @(posedge clk);

            #1 we = 0;
            raddr = 8'hFF;
            #2;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable De-assertion", test_num);
            reset_dut();


            waddr = 8'h10; wdata = 16'hBEEF; we = 1;
            @(posedge clk);


            #1 waddr = 8'h10; wdata = 16'hDEAD; we = 0;
            @(posedge clk);


            #1 raddr = 8'h10;
            #2;

            #1;


            check_outputs(16'hBEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asynchronous Read Timing", test_num);
            reset_dut();


            waddr = 8'h01; wdata = 16'h1111; we = 1; @(posedge clk);
            waddr = 8'h02; wdata = 16'h2222; we = 1; @(posedge clk);
            #1 we = 0;


            raddr = 8'h01;
            #1;
            if (rdata !== 16'h1111) $display("Async Read Error at Addr 01");

            raddr = 8'h02;
            #1;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data Persistence", test_num);
            reset_dut();


            waddr = 8'h20; wdata = 16'h9999; we = 1;
            @(posedge clk);


            #1 waddr = 8'h21; wdata = 16'h8888; we = 1;
            @(posedge clk);

            #1 we = 0;
            raddr = 8'h20;
            #2;

            #1;


            check_outputs(16'h9999);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous Read/Write same address", test_num);
            reset_dut();


            raddr = 8'h50;
            waddr = 8'h50;
            wdata = 16'hABCD;
            we = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ram_256x16_dp Testbench");
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
        $dumpvars(0,clk, raddr, waddr, wdata, we, rdata);
    end

endmodule
