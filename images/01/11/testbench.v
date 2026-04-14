`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg DIN;
    reg READ;
    reg WRITE;
    reg clk;
    wire DOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .DIN(DIN),
        .READ(READ),
        .WRITE(WRITE),
        .clk(clk),
        .DOUT(DOUT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            DIN = 0;
            READ = 0;
            WRITE = 0;
            @(posedge clk);


            WRITE = 1;
            DIN = 0;
            @(posedge clk);
            WRITE = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write 1 then Read 1", test_num);
            reset_dut();


            DIN = 1;
            WRITE = 1;
            READ = 0;
            @(posedge clk);


            WRITE = 0;
            READ = 1;
            @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write 0 then Read 0", test_num);
            reset_dut();


            DIN = 1;
            WRITE = 1;
            @(posedge clk);


            DIN = 0;
            WRITE = 1;
            READ = 0;
            @(posedge clk);


            WRITE = 0;
            READ = 1;
            @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite 1 with 0", test_num);
            reset_dut();


            DIN = 1;
            WRITE = 1;
            @(posedge clk);


            DIN = 0;
            WRITE = 1;
            @(posedge clk);


            WRITE = 0;
            READ = 1;
            @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data retention check", test_num);
            reset_dut();


            DIN = 1;
            WRITE = 1;
            @(posedge clk);


            WRITE = 0;
            READ = 0;
            DIN = 0;
            repeat(5) @(posedge clk);


            READ = 1;
            @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read enable logic", test_num);
            reset_dut();


            DIN = 1;
            WRITE = 1;
            @(posedge clk);


            WRITE = 0;
            DIN = 0;



            READ = 1;
            @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write enable logic", test_num);
            reset_dut();




            DIN = 1;
            WRITE = 0;
            @(posedge clk);


            READ = 1;
            @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input expected_DOUT;
        begin
            if (expected_DOUT === (expected_DOUT ^ DOUT ^ expected_DOUT)) begin
                $display("PASS");
                $display("  Outputs: DOUT=%b",
                         DOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUT=%b",
                         expected_DOUT);
                $display("  Got:      DOUT=%b",
                         DOUT);
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
        $dumpvars(0,DIN, READ, WRITE, clk, DOUT);
    end

endmodule
