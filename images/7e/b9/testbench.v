`timescale 1ns/1ps

module synchronous_ram_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg [3:0] read_addr;
    reg we;
    reg [3:0] write_addr;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    synchronous_ram dut (
        .clk(clk),
        .din(din),
        .read_addr(read_addr),
        .we(we),
        .write_addr(write_addr),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            we <= 0;
            din <= 0;
            write_addr <= 0;
            read_addr <= 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            we <= 1;
            write_addr <= 4'h4;
            din <= 8'hA5;
            @(posedge clk);


            we <= 0;
            read_addr <= 4'h4;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Check (we=0)", test_num);
            reset_dut();


            we <= 0;
            write_addr <= 4'h7;
            din <= 8'h55;
            @(posedge clk);


            read_addr <= 4'h7;
            @(posedge clk);

            #1;


            if (dout !== 8'h55) begin
                pass_count = pass_count + 1;
                $display("PASS: Write inhibited as expected");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Write occurred despite we=0");
            end
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite existing data", test_num);
            reset_dut();


            we <= 1;
            write_addr <= 4'hA;
            din <= 8'h11;
            @(posedge clk);


            din <= 8'h22;
            @(posedge clk);

            we <= 0;
            read_addr <= 4'hA;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            we <= 1;
            write_addr <= 4'h1;
            din <= 8'hCC;
            @(posedge clk);


            we <= 1;
            write_addr <= 4'h2;
            din <= 8'hDD;
            read_addr <= 4'h1;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address Check (0 and 15)", test_num);
            reset_dut();


            we <= 1;
            write_addr <= 4'h0;
            din <= 8'h01;
            @(posedge clk);


            write_addr <= 4'hF;
            din <= 8'hFF;
            @(posedge clk);

            we <= 0;
            read_addr <= 4'hF;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'hFF);

            read_addr <= 4'h0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("synchronous_ram Testbench");
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
        $dumpvars(0,clk, din, read_addr, we, write_addr, dout);
    end

endmodule
