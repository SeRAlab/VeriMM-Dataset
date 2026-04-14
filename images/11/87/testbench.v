`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] instruction_in;
    reg rst;
    wire [15:0] decoded;
    wire [15:0] executed;
    wire [15:0] fetched;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .rst(rst),
        .decoded(decoded),
        .executed(executed),
        .fetched(fetched)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            instruction_in = 16'h0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Instruction Propagation", test_num);
            reset_dut();


            instruction_in = 16'hAAAA;
            @(posedge clk);


            instruction_in = 16'h0000;
            @(posedge clk);


            @(posedge clk);

            #1;

            #1;


            check_outputs(16'h0000, 16'hAAAA, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Continuous Instruction Stream", test_num);
            reset_dut();


            instruction_in = 16'h1111;
            @(posedge clk);


            instruction_in = 16'h2222;
            @(posedge clk);


            instruction_in = 16'h3333;
            @(posedge clk);


            instruction_in = 16'h4444;
            @(posedge clk);

            #1;




            #1;





            check_outputs(16'h3333, 16'h2222, 16'h4444);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-operation Reset", test_num);
            reset_dut();


            instruction_in = 16'hBBBB;
            @(posedge clk);
            instruction_in = 16'hCCCC;
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;
            #1;


            #1;



            check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bit Patterns", test_num);
            reset_dut();

            instruction_in = 16'hFFFF;
            @(posedge clk);
            instruction_in = 16'h0000;
            @(posedge clk);
            instruction_in = 16'hFFFF;
            @(posedge clk);

            #1;

            #1;


            check_outputs(16'h0000, 16'hFFFF, 16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("instruction_pipeline Testbench");
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
        input [15:0] expected_decoded;
        input [15:0] expected_executed;
        input [15:0] expected_fetched;
        begin
            if (expected_decoded === (expected_decoded ^ decoded ^ expected_decoded) &&
                expected_executed === (expected_executed ^ executed ^ expected_executed) &&
                expected_fetched === (expected_fetched ^ fetched ^ expected_fetched)) begin
                $display("PASS");
                $display("  Outputs: decoded=%h, executed=%h, fetched=%h",
                         decoded, executed, fetched);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded=%h, executed=%h, fetched=%h",
                         expected_decoded, expected_executed, expected_fetched);
                $display("  Got:      decoded=%h, executed=%h, fetched=%h",
                         decoded, executed, fetched);
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
        $dumpvars(0,clk, instruction_in, rst, decoded, executed, fetched);
    end

endmodule
